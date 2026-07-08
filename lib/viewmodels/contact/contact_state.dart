import '../../data/app_database.dart';

abstract class ContactState {}

class ContactLoadingState extends ContactState {}

class ContactLoadedState extends ContactState {
  final List<Contact> contacts;

  ContactLoadedState({required this.contacts});
}

class ContactErrorState extends ContactState {
  final String message;

  ContactErrorState(this.message);
}

class ContactValidationError extends ContactState {
  final String message;

  ContactValidationError(this.message);
}

class ContactSubmitSuccess extends ContactState {}