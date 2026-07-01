import 'package:drift/drift.dart';

import 'contacts.dart';

class Transactions extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text()();
  RealColumn get value => real()();
  TextColumn get type => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get contactId => integer().nullable().references(Contacts, #id)();
}