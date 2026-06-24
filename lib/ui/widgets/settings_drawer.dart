import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/my_account/my_account_bloc.dart';
import '../../bloc/my_account/my_account_state.dart';

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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              children: [
                const SizedBox(height: 20),

                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                    'assets/images/deel.jpg',
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  state.account.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Editar Perfil'),
                  onTap: () {},
                ),

                SwitchListTile(
                  secondary: const Icon(Icons.account_balance),
                  title: const Text('Modo Bancário'),
                  value: true,
                  onChanged: (value) {},
                ),

                Row(
  children: [
    IconButton(
      icon: const Icon(Icons.light_mode),
      onPressed: () {
        // tema claro
      },
    ),

    IconButton(
      icon: const Icon(Icons.dark_mode),
      onPressed: () {
        // tema escuro
      },
    ),
  ],
)

              ],
            );
          },
        ),
      ),
    );
  }
}