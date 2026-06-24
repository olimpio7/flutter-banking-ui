import 'package:drift/drift.dart';
import 'package:flutter_banking_ui/data/database/app_database.dart';

import '../tables/transactions.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(
  tables : [Transactions]
)

class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin{
  TransactionDao(super.db);

  Future<List<Transaction>> getAllTransactions() => select(transactions).get();

  Future insertTransaction(TransactionsCompanion transaction) => into(transactions).insert(transaction);

  Future updateTransaction(Transaction transaction) => update(transactions).replace(transaction);

  Future deleteTransaction(Transaction transaction) => delete(transactions).delete(transaction);

  Future<bool> hasTransactionsForContact(int contactId) async {
  final result =
      await (select(transactions)
            ..where((t) => t.contactId.equals(contactId)))
          .get();

  return result.isNotEmpty;
}
}