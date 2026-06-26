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
import 'drawer_account_actions.dart';
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

                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/deel.jpg'),
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

                // 1. EDITAR PERFIL
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Editar Perfil'),
                  onTap: () {
                    Navigator.pop(context); // Fecha a drawer
                    DrawerAccountActions.showEditProfileDialog(context);
                  },
                ),

                // 2. MODO BANCÁRIO
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

                // 3. TEMA (Minimalista)
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

                const Spacer(), // Empurra os últimos botões para o rodapé

                const Divider(),

                // 4. AÇÕES DE CONTA
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Excluir conta', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => ConfirmationDialog(
                        title: 'Excluir Conta',
                        message: 'Tem certeza? Todo o seu saldo, histórico de transações e contatos serão apagados permanentemente.',
                        confirmText: 'Excluir Tudo',
                        onConfirm: () async {
                          Navigator.pop(dialogContext); // Fecha o dialog
                          Navigator.pop(context); // Fecha a drawer

                          final db = context.read<AppDatabase>();
                          await db.clearAllData();

                          if (context.mounted) {
                            context.read<MyAccountBloc>().add(LoadMyAccountEvent());
                            context.read<TransactionBloc>().add(LoadTransactionEvent());
                            context.read<ContactBloc>().add(LoadContactsEvent());

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Conta excluída com sucesso.'),
                                backgroundColor: Colors.redAccent,
                              ),
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