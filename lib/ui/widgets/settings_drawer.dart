import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/bloc/bank_mode/bank_mode_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/my_account/my_account_bloc.dart';
import '../../bloc/my_account/my_account_state.dart';
import '../../theme/app_theme.dart';
import 'drawer_account_actions.dart';

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

                const Spacer(), // Empurra os botões de tema para o rodapé

                const Divider(),

                // 3. ÁREA DE SELEÇÃO DE TEMA INTEGRADA AO CUBIT
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: BlocBuilder<ThemeCubit, ThemeMode>(
                    bloc: ThemeCubit.instance, // Escuta o Cubit global unificado
                    builder: (context, themeMode) {
                      final isDark = themeMode == ThemeMode.dark;

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          // Se adapta visualmente ao tema ativo para destacar o card
                          color: isDark ? Colors.grey[900] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Aparência',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              children: [
                                // Botão de Modo Claro (Sol)
                                IconButton(
                                  icon: Icon(
                                    Icons.light_mode,
                                    color: !isDark ? Colors.orange : Colors.grey,
                                  ),
                                  onPressed: () => ThemeCubit.instance.toggleTheme(false), // Ativa Light
                                ),
                                // Botão de Modo Escuro (Lua)
                                IconButton(
                                  icon: Icon(
                                    Icons.dark_mode,
                                    color: isDark ? Colors.purpleAccent : Colors.grey,
                                  ),
                                  onPressed: () => ThemeCubit.instance.toggleTheme(true), // Ativa Dark
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}