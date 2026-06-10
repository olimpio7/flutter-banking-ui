import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/ui/initial_page.dart';

import 'data/database/app_database.dart';
import 'data/database/dao/contact_dao.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final dao = ContactDao(db);

  print('\n--- iniciando teste ---');

  final newId = await dao.insertContact(
    ContactsCompanion.insert(name: 'kate'),
  );
  print('contato adicionado com sucesso: id gerado: $newId');

  var allContacts = await dao.getAllContacts();
  print('contatos no banco : $allContacts');

  final kate = allContacts.firstWhere((c) => c.id == newId);
  final updatedContact = kate.copyWith(name: 'kate updated');
  await dao.updateContact(updatedContact);

  print('--- apos o update ---');
  allContacts = await dao.getAllContacts();
  print('contatos atualizados: $allContacts');

  await dao.deleteContact(updatedContact);

  print('--- apos a exclusão ---');
  allContacts = await dao.getAllContacts();
  print('contatos restantes: $allContacts\n');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roble'),
      home: InitialPage()
    );
  }
}