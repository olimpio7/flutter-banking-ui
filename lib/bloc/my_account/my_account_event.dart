import '../../data/database/app_database.dart';

abstract class MyAccountEvent {}

class LoadMyAccountEvent extends MyAccountEvent {}

class CreateMyAccountEvent extends MyAccountEvent {
  final MyAccountsCompanion account;

  CreateMyAccountEvent(this.account);
}
