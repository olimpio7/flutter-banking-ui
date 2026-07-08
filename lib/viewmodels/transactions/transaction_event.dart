import 'package:flutter_banking_ui/data/app_database.dart';

abstract class TransactionEvent {}

class LoadTransactionEvent extends TransactionEvent {}

class CreateTransactionEvent extends TransactionEvent {
  final TransactionsCompanion transaction;

  CreateTransactionEvent({required this.transaction});
}

class UpdateTransactionEvent extends TransactionEvent {
  final Transaction transaction;

  UpdateTransactionEvent({
    required this.transaction,
  });
}

class DeleteTransactionEvent extends TransactionEvent {
  final Transaction transaction;

  DeleteTransactionEvent({
    required this.transaction,
  });
}

class SubmitTransactionEvent extends TransactionEvent {
  final String description;
  final String rawValue;
  final bool isDeposit;
  final int? contactId;

  SubmitTransactionEvent({
    required this.description,
    required this.rawValue,
    required this.isDeposit,
    this.contactId,
  });
}

class SubmitEditTransactionEvent extends TransactionEvent {
  final Transaction originalTransaction;
  final String newDescription;
  final String rawValue;

  SubmitEditTransactionEvent({
    required this.originalTransaction,
    required this.newDescription,
    required this.rawValue,
  });
}
