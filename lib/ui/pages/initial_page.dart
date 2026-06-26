import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/my_account/my_account_bloc.dart';
import '../../bloc/my_account/my_account_event.dart';
import '../../bloc/my_account/my_account_state.dart';
import '../../data/database/app_database.dart';
import '../widgets/initial_balance_header.dart';
import '../widgets/initial_favorites_section.dart';
import '../widgets/initial_quick_actions.dart';
import '../widgets/initial_recent_transactions.dart';
import '../widgets/settings_drawer.dart';
import '../widgets/soft_container.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SettingsDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: BlocBuilder<MyAccountBloc, MyAccountState>(
            builder: (context, state) {
              if (state is MyAccountLoadingState) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is MyAccountNotFoundState) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final newAccount = MyAccountsCompanion.insert(
                        name: 'Olimpio Carvalho',
                        balance: 0.0,
                      );
                      context.read<MyAccountBloc>().add(
                        CreateMyAccountEvent(newAccount),
                      );
                    },
                    child: const Text('Criar Conta'),
                  ),
                );
              }

              if (state is MyAccountErrorState) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (state is MyAccountLoadedState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InitialBalanceHeader(account: state.account),
                    const InitialQuickActions(),
                    Expanded(
                      child: SoftContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const InitialFavoritesSection(),
                            const Expanded(
                              child: InitialRecentTransactions(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}