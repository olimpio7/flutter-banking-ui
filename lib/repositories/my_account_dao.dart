import 'package:drift/drift.dart';
import 'package:flutter_banking_ui/data/app_database.dart';

import '../models/my_accounts.dart';

part 'my_account_dao.g.dart';

@DriftAccessor(
  tables : [MyAccounts]
)

class MyAccountDao extends DatabaseAccessor<AppDatabase> with _$MyAccountDaoMixin{
  MyAccountDao(super.db);

  Future<MyAccount?> getMyAccount() => select(myAccounts).getSingleOrNull();

  Future insertMyAccount(MyAccountsCompanion account) => into(myAccounts).insert(account);

  Future updateMyAccount(MyAccount account) => update(myAccounts).replace(account);

  Future deleteMyAccount(MyAccount account) => delete(myAccounts).delete(account);
}