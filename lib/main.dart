import 'package:flutter/material.dart';

import 'package:flutter_banking_ui/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'viewmodels/contact/contact_bloc.dart';
import 'viewmodels/contact/contact_event.dart';
import 'viewmodels/my_account/my_account_bloc.dart';
import 'viewmodels/my_account/my_account_event.dart';
import 'viewmodels/transactions/transaction_bloc.dart';
import 'viewmodels/transactions/transaction_event.dart';
import 'data/app_database.dart';
import 'repositories/contact_dao.dart';
import 'repositories/my_account_dao.dart';
import 'repositories/transaction_dao.dart';
import 'views/pages/initial_page.dart';

void main() {
  runApp(MainApp(database: AppDatabase()));
}

class MainApp extends StatelessWidget {
  final AppDatabase database;

  const MainApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AppDatabase>.value(
      value: database,
      child: MultiBlocProvider(
        providers: [
        BlocProvider(
          create: (context) => MyAccountBloc(MyAccountDao(context.read<AppDatabase>()))..add(LoadMyAccountEvent()),
        ),
        BlocProvider(
          create: (context) => ContactBloc(ContactDao(context.read<AppDatabase>()), TransactionDao(context.read<AppDatabase>()))..add(LoadContactsEvent()),
        ),
        BlocProvider(
          create: (context) => TransactionBloc(TransactionDao(context.read<AppDatabase>()),
          context.read<MyAccountBloc>())..add(LoadTransactionEvent()),
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
      )
    );
  }
}