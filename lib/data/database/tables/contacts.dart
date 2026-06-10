import 'package:drift/drift.dart';

class Contacts extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get avatar => text().nullable()();
  TextColumn get paymentLogo => text().nullable()();
}