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
}