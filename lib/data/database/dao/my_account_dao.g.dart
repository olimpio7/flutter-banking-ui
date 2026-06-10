// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_account_dao.dart';

// ignore_for_file: type=lint
mixin _$MyAccountDaoMixin on DatabaseAccessor<AppDatabase> {
  $MyAccountsTable get myAccounts => attachedDatabase.myAccounts;
  MyAccountDaoManager get managers => MyAccountDaoManager(this);
}

class MyAccountDaoManager {
  final _$MyAccountDaoMixin _db;
  MyAccountDaoManager(this._db);
  $$MyAccountsTableTableManager get myAccounts =>
      $$MyAccountsTableTableManager(_db.attachedDatabase, _db.myAccounts);
}
