import '../../data/app_database.dart';

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

class MyAccountValidationError extends MyAccountState {
  final String message;

  MyAccountValidationError(this.message);
}

class MyAccountSubmitSuccess extends MyAccountState {}