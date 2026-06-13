import 'package:flutter_banking_ui/data/database/app_database.dart';

abstract class TransactionEvent {}

class LoadTransactionEvent extends TransactionEvent {}

class CreateTransactionEvent extends TransactionEvent {
  final TransactionsCompanion transaction;

  CreateTransactionEvent({required this.transaction});
}

