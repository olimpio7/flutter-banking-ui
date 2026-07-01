import 'package:drift/drift.dart';
import 'package:flutter_banking_ui/database/app_database.dart';

import '../tables/contacts.dart';

part 'contact_dao.g.dart';

@DriftAccessor(
  tables : [Contacts]
)

class ContactDao extends DatabaseAccessor<AppDatabase>
  with _$ContactDaoMixin{
    ContactDao(super.db);

  Future<List<Contact>> getAllContacts() => select(contacts).get();

  Future insertContact(ContactsCompanion contact) => into(contacts).insert(contact);

  Future updateContact(Contact contact) => update(contacts).replace(contact);

  Future deleteContact(Contact contact) => delete(contacts).delete(contact);
}
  

