import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/bloc/contact/contact_bloc.dart';
import 'package:flutter_banking_ui/bloc/contact/contact_event.dart';
import 'package:flutter_banking_ui/bloc/my_account/my_account_bloc.dart';
import 'package:flutter_banking_ui/bloc/my_account/my_account_event.dart';
import 'package:flutter_banking_ui/bloc/transactions/transaction_bloc.dart';
import 'package:flutter_banking_ui/bloc/transactions/transaction_event.dart';
import 'package:flutter_banking_ui/data/database/dao/contact_dao.dart';
import 'package:flutter_banking_ui/data/database/dao/my_account_dao.dart';
import 'package:flutter_banking_ui/data/database/dao/transaction_dao.dart';
import 'package:flutter_banking_ui/ui/pages/initial_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/database/app_database.dart';

void main() {
  runApp(MainApp(database: AppDatabase()));
}

class MainApp extends StatelessWidget {
  final AppDatabase database;

  const MainApp({super.key,required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roble'),
      home: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MyAccountBloc(MyAccountDao(database))..add(LoadMyAccountEvent()),
          ),
        BlocProvider(
          create: (_) => ContactBloc(ContactDao(database))..add(LoadContactsEvent()),
          ),
        BlocProvider(
          create: (_) => TransactionBloc(TransactionDao(database))..add(LoadTransactionEvent())
          ),
      ],
      child: const InitialPage(),
    )
    );
  }
}