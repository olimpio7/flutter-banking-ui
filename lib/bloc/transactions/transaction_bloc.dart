import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/database/dao/transaction_dao.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState>{
  final TransactionDao _dao;

  TransactionBloc(this._dao) : super(TransactionLoadingState()) {
    on<LoadTransactionEvent>((event, emit) async{
      emit(TransactionLoadingState());

      try {
        final transactions = await _dao.getAllTransactions();
        emit(TransactionLoadedState(transactions: transactions));
      } catch (e) {
        emit(TransactionErrorState('Erro ao carregar as transações : $e'));
      }
    }
    );
    on<CreateTransactionEvent>((event, emit) async {
      emit(TransactionLoadingState());

      try {
        await _dao.insertTransaction(event.transaction);
        add(LoadTransactionEvent());
      } catch (e) {
        emit(TransactionErrorState('Erro ao criar transação: $e'));
      }
    }
    );
  }
}


