import "package:drift/drift.dart";

class MyAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get balance => real()();
  TextColumn get imagePath => text().nullable()();
}