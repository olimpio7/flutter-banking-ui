import '../../data/database/app_database.dart';

abstract class MyAccountState {}

class MyAccountLoadingState extends MyAccountState {}

class MyAccountLoadedState extends MyAccountState {
  final MyAccount account;

  MyAccountLoadedState(this.account);
}

class MyAccountNotFoundState extends MyAccountState {}

class MyAccountErrorState extends MyAccountState {
  final String message;

  MyAccountErrorState(this.message);
}