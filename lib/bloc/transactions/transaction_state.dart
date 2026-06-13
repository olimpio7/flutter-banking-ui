import '../../data/database/app_database.dart';

abstract class TransactionState {}

class TransactionLoadingState extends TransactionState {}

class TransactionLoadedState extends TransactionState {
  final List<Transaction> transactions;

  TransactionLoadedState({required this.transactions});
}

class TransactionErrorState extends TransactionState {
  final String message;

  TransactionErrorState(this.message);
}
