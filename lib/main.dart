import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/bloc/bank_mode/bank_mode_cubit.dart';
import 'package:flutter_banking_ui/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/contact/contact_bloc.dart';
import 'bloc/contact/contact_event.dart';
import 'bloc/my_account/my_account_bloc.dart';
import 'bloc/my_account/my_account_event.dart';
import 'bloc/transactions/transaction_bloc.dart';
import 'bloc/transactions/transaction_event.dart';
import 'data/database/app_database.dart';
import 'data/database/dao/contact_dao.dart';
import 'data/database/dao/my_account_dao.dart';
import 'data/database/dao/transaction_dao.dart';
import 'ui/pages/initial_page.dart';

void main() {
  runApp(MainApp(database: AppDatabase()));
}

class MainApp extends StatelessWidget {
  final AppDatabase database;

  const MainApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MyAccountBloc(MyAccountDao(database))..add(LoadMyAccountEvent()),
        ),
        BlocProvider(
          create: (_) => ContactBloc(ContactDao(database), TransactionDao(database))..add(LoadContactsEvent()),
        ),
        BlocProvider(
          create: (context) => TransactionBloc(TransactionDao(database),
          context.read<MyAccountBloc>())..add(LoadTransactionEvent()),
        ),
        BlocProvider<BankModeCubit>(
          create: (_) => BankModeCubit(), 
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        bloc: ThemeCubit.instance,
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const InitialPage(),
          );
        }
      ),
    );
  }
}