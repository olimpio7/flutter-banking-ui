import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/bloc/bank_mode/bank_mode_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/my_account/my_account_bloc.dart';
import '../../bloc/my_account/my_account_state.dart';
import '../../bloc/my_account/my_account_event.dart';
import '../../bloc/contact/contact_bloc.dart';
import '../../bloc/contact/contact_event.dart';
import '../../bloc/transactions/transaction_bloc.dart';
import '../../bloc/transactions/transaction_event.dart';
import '../../data/database/app_database.dart';
import '../../theme/app_theme.dart';
import '../pages/initial_page.dart';
import 'drawer_account_actions.dart';
import 'user_avatar.dart';
import 'confirmation_dialog.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      child: SafeArea(
        child: BlocBuilder<MyAccountBloc, MyAccountState>(
          builder: (context, state) {
            if (state is! MyAccountLoadedState) {
              return const Center(child: CircularProgressIndicator());
            }

            final account = state.account;

            return Column(
              children: [
                const SizedBox(height: 20),

                UserAvatar(
                  name: account.name,
                  imagePath: account.imagePath,
                  radius: 40,
                ),

                const SizedBox(height: 12),

                Text(
                  account.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Editar Perfil'),
                  onTap: () {
                    Navigator.pop(context);
                    DrawerAccountActions.showEditProfileDialog(context);
                  },
                ),

                BlocBuilder<BankModeCubit, bool>(
                  builder: (context, isBankModeOn) {
                    return SwitchListTile(
                      secondary: const Icon(Icons.account_balance),
                      title: const Text('Modo Bancário'),
                      value: isBankModeOn,
                      onChanged: (value) {
                        context.read<BankModeCubit>().toggleMode();
                      },
                    );
                  },
                ),

                BlocBuilder<ThemeCubit, ThemeMode>(
                  bloc: ThemeCubit.instance,
                  builder: (context, themeMode) {
                    final isDark = themeMode == ThemeMode.dark;
                    return ListTile(
                      leading: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                      ),
                      title: Text(isDark ? 'Modo Escuro' : 'Modo Claro'),
                      onTap: () {
                        ThemeCubit.instance.toggleTheme(!isDark);
                      },
                    );
                  },
                ),

                const Spacer(),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Excluir conta', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => ConfirmationDialog(
                        title: 'Excluir Conta',
                        message: 'Tem certeza? Todo o serão apagados permanentemente.',
                        confirmText: 'Excluir Tudo',
                        onConfirm: () async {
                          final myAccountBloc = context.read<MyAccountBloc>();
                          final transactionBloc = context.read<TransactionBloc>();
                          final contactBloc = context.read<ContactBloc>();
                          final db = context.read<AppDatabase>();

                          Navigator.pop(dialogContext);

                          await db.clearAllData();

                          myAccountBloc.add(LoadMyAccountEvent());
                          transactionBloc.add(LoadTransactionEvent());
                          contactBloc.add(LoadContactsEvent());

                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const InitialPage()),
                              (route) => false,
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}