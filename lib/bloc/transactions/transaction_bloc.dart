import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/database/dao/transaction_dao.dart';
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

    on<CreateTransactionEvent>((event, emit) async {
      emit(TransactionLoadingState());
      try {
        await _dao.insertTransaction(event.transaction);
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
  }
}