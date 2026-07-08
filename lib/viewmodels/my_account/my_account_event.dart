import '../../data/app_database.dart';

abstract class MyAccountEvent {}

class LoadMyAccountEvent extends MyAccountEvent {}

class CreateMyAccountEvent extends MyAccountEvent {
  final MyAccountsCompanion account;

  CreateMyAccountEvent(this.account);
}

class UpdateMyAccountEvent extends MyAccountEvent {
  final MyAccount account;

  UpdateMyAccountEvent(this.account);
}

class DeleteMyAccountEvent extends MyAccountEvent {
  final MyAccount account;

  DeleteMyAccountEvent(this.account);
}

class SubmitMyAccountEvent extends MyAccountEvent {
  final String name;
  final String rawBalance;

  SubmitMyAccountEvent(this.name, this.rawBalance);
}
