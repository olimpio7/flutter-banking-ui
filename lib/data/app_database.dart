import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/my_accounts.dart';
import '../models/contacts.dart';
import '../models/transactions.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    MyAccounts,
    Contacts,
    Transactions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(transactions).go();
      await delete(contacts).go();
      await delete(myAccounts).go();
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(
      p.join(
        dir.path,
        'app_database_V4.sqlite',
      )
    );
    return NativeDatabase(file);
  }
);
}