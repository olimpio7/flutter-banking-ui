import 'package:flutter_banking_ui/data/database/app_database.dart';

abstract class ContactEvent {}

class LoadContactsEvent extends ContactEvent {}

class CreateContactEvent extends ContactEvent {
  final ContactsCompanion contact;

  CreateContactEvent({required this.contact});
}

class UpdateContactEvent extends ContactEvent {
  final Contact contact;

  UpdateContactEvent({required this.contact});
}

class DeleteContactEvent extends ContactEvent {
  final Contact contact;

  DeleteContactEvent({required this.contact});
}

