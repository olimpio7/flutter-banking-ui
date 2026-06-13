import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/bloc/my_account/my_account_bloc.dart';
import 'package:flutter_banking_ui/bloc/my_account/my_account_event.dart';
import 'package:flutter_banking_ui/data/database/dao/my_account_dao.dart';
import 'package:flutter_banking_ui/ui/pages/initial_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/database/app_database.dart';

void main() {
  runApp(MainApp(dao: MyAccountDao(AppDatabase())));
}

class MainApp extends StatelessWidget {
  final MyAccountDao dao;

  const MainApp({super.key,required this.dao});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roble'),
      home: BlocProvider(
        create: (context) => MyAccountBloc(dao)..add(LoadMyAccountEvent()),
      child: const InitialPage(),
    )
    );
  }
}