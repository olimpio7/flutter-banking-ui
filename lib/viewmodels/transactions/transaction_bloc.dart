import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/app_database.dart';

import '../../repositories/transaction_dao.dart';
import '../my_account/my_account_bloc.dart';
import '../my_account/my_account_event.dart';
import '../my_account/my_account_state.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionDao _dao;
  final MyAccountBloc _accountBloc;

  TransactionBloc(this._dao, this._accountBloc) : super(TransactionLoadingState()) {
    
    on<LoadTransactionEvent>((event, emit) async {
      emit(TransactionLoadingState());
      try {
        final transactions = await _dao.getAllTransactions();
        emit(TransactionLoadedState(transactions: transactions));
      } catch (e) {
        emit(TransactionErrorState('Erro ao carregar as transações : $e'));
      }
    });

    on<SubmitTransactionEvent>((event, emit) async {
      final description = event.description.trim();
      String cleanString = event.rawValue.replaceAll('R\$', '').replaceAll('.', '').replaceAll(',', '.').trim();
      final value = double.tryParse(cleanString);

      if (value == null || value <= 0) {
        emit(TransactionValidationError('Informe um valor maior que zero.'));
        return;
      }

      if (description.isEmpty) {
        emit(TransactionValidationError('Preencha o título.'));
        return;
      }

      if (!event.isDeposit) {
        if (_accountBloc.state is MyAccountLoadedState) {
          final account = (_accountBloc.state as MyAccountLoadedState).account;
          if (value > account.balance) {
            emit(TransactionValidationError('Saldo insuficiente'));
            return;
          }
        }
      }

      final transaction = TransactionsCompanion.insert(
        description: description,
        value: value,
        type: event.isDeposit ? 'income' : 'expense',
        createdAt: DateTime.now(),
        contactId: drift.Value(event.contactId),
      );

      emit(TransactionLoadingState());
      try {
        await _dao.insertTransaction(transaction);

        if (_accountBloc.state is MyAccountLoadedState) {
          final account = (_accountBloc.state as MyAccountLoadedState).account;
          
          final newBalance = event.isDeposit
              ? account.balance + value
              : account.balance - value;

          _accountBloc.add(UpdateMyAccountEvent(account.copyWith(balance: newBalance)));
        }

        emit(TransactionSubmitSuccess());
        add(LoadTransactionEvent());
      } catch (e) {
        emit(TransactionErrorState('Erro ao criar transação: $e'));
      }
    });

    on<CreateTransactionEvent>((event, emit) async {
      emit(TransactionLoadingState());
      try {
        await _dao.insertTransaction(event.transaction);

        if (_accountBloc.state is MyAccountLoadedState) {
          final account = (_accountBloc.state as MyAccountLoadedState).account;
          final value = event.transaction.value.value;
          final type = event.transaction.type.value;
          
          final newBalance = type == 'income'
              ? account.balance + value
              : account.balance - value;

          _accountBloc.add(UpdateMyAccountEvent(account.copyWith(balance: newBalance)));
        }

        add(LoadTransactionEvent());
      } catch (e) {
        emit(TransactionErrorState('Erro ao criar transação: $e'));
      }
    });

    on<UpdateTransactionEvent>((event, emit) async {
      emit(TransactionLoadingState());
      try {
        final allTransactions = await _dao.getAllTransactions();
        final oldTransaction = allTransactions.firstWhere((t) => t.id == event.transaction.id);

        await _dao.updateTransaction(event.transaction);

        if (_accountBloc.state is MyAccountLoadedState) {
          final account = (_accountBloc.state as MyAccountLoadedState).account;
          double currentBalance = account.balance;
          currentBalance += oldTransaction.type == 'expense' ? oldTransaction.value : -oldTransaction.value;
          currentBalance += event.transaction.type == 'expense' ? -event.transaction.value : event.transaction.value;

          _accountBloc.add(UpdateMyAccountEvent(account.copyWith(balance: currentBalance)));
        }

        add(LoadTransactionEvent());
      } catch (e) {
        emit(TransactionErrorState('Erro ao atualizar transação: $e'));
      }
    });

    on<DeleteTransactionEvent>((event, emit) async {
      emit(TransactionLoadingState());
      try {
        await _dao.deleteTransaction(event.transaction);

        if (_accountBloc.state is MyAccountLoadedState) {
          final account = (_accountBloc.state as MyAccountLoadedState).account;
          
          final newBalance = event.transaction.type == 'expense'
              ? account.balance + event.transaction.value  
              : account.balance - event.transaction.value;

          _accountBloc.add(UpdateMyAccountEvent(account.copyWith(balance: newBalance)));
        }

        add(LoadTransactionEvent());
      } catch (e) {
        emit(TransactionErrorState('Erro ao excluir transação: $e'));
      }
    });

    on<SubmitEditTransactionEvent>((event, emit) async {
      final description = event.newDescription.trim();
      final valueStr = event.rawValue.trim();
      
      if (description.isEmpty) {
        emit(TransactionValidationError('A descrição não pode ser vazia.'));
        return;
      }

      final value = double.tryParse(valueStr) ?? event.originalTransaction.value;

      final updatedTransaction = event.originalTransaction.copyWith(
        description: description,
        value: value,
      );

      emit(TransactionLoadingState());
      try {
        final allTransactions = await _dao.getAllTransactions();
        final oldTransaction = allTransactions.firstWhere((t) => t.id == updatedTransaction.id);

        await _dao.updateTransaction(updatedTransaction);

        if (_accountBloc.state is MyAccountLoadedState) {
          final account = (_accountBloc.state as MyAccountLoadedState).account;
          double currentBalance = account.balance;
          currentBalance += oldTransaction.type == 'expense' ? oldTransaction.value : -oldTransaction.value;
          currentBalance += updatedTransaction.type == 'expense' ? -updatedTransaction.value : updatedTransaction.value;

          _accountBloc.add(UpdateMyAccountEvent(account.copyWith(balance: currentBalance)));
        }

        emit(TransactionSubmitSuccess());
        add(LoadTransactionEvent());
      } catch (e) {
        emit(TransactionErrorState('Erro ao atualizar transação: $e'));
      }
    });
  }

  static List<String> buildQuickTags({required bool isDeposit, String? contactFirstName}) {
    if (isDeposit) {
      return [
        if (contactFirstName != null) 'Pix de $contactFirstName',
        'Salário',
        'Venda',
        'Depósito',
      ];
    } else {
      return [
        if (contactFirstName != null) 'Pix para $contactFirstName',
        'Mercado',
        'Aluguel',
        'Boleto',
      ];
    }
  }
}