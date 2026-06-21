import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/bloc/contact/contact_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/contact/contact_bloc.dart';
import '../../bloc/contact/contact_state.dart';

class ManageFavoritesPage extends StatelessWidget {
  const ManageFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Favoritos')),
      body: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          if (state is ContactLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ContactErrorState) {
            return Center(child: Text(state.message));
          }

          if (state is ContactLoadedState) {
            if (state.contacts.isEmpty) {
              return const Center(child: Text('Nenhum favorito cadastrado'));
            }

            return ListView.builder(
              itemCount: state.contacts.length,
              itemBuilder: (context, index) {
                final contact = state.contacts[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: contact.avatar != null
                        ? AssetImage(contact.avatar!)
                        : null,
                    child: contact.avatar == null
                        ? Text(contact.name[0])
                        : null,
                  ),
                  title: Text(contact.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      context.read<ContactBloc>().add(
                        DeleteContactEvent(contact: contact)
                      );
                    },
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
