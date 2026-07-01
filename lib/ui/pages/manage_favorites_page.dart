import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/bloc/contact/contact_event.dart';
import 'package:flutter_banking_ui/ui/widgets/confirmation_dialog.dart';
import 'package:flutter_banking_ui/ui/widgets/edit_contact_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/contact/contact_bloc.dart';
import '../../bloc/contact/contact_state.dart';
import '../widgets/soft_container.dart';
import '../widgets/avatar.dart';

class ManageFavoritesPage extends StatelessWidget {
  const ManageFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Favoritos'),
        backgroundColor: Color(0xFFF5F5F7),
      ),
      body: BlocListener<ContactBloc, ContactState>(
        listener: (context, state) {
          if (state is ContactErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<ContactBloc, ContactState>(
          builder: (context, state) {
            if (state is ContactLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ContactLoadedState) {
              if (state.contacts.isEmpty) {
                return const Center(child: Text('Nenhum favorito cadastrado'));
              }

              return ListView.builder(
                itemCount: state.contacts.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.contacts.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: SoftContainer(
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: const Icon(Icons.add, color: Colors.grey),
                          ),
                          title: const Text('Novo Favorito'),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => BlocProvider.value(
                                value: context.read<ContactBloc>(),
                                child: const ContactDialog(contact: null),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }

                  final contact = state.contacts[index];

                return ListTile(
                  leading: UserAvatar(
                    name: contact.name,
                    imagePath: contact.avatar,
                    radius: 20,
                  ),
                  title: Text(contact.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => BlocProvider.value(
                              value: context.read<ContactBloc>(),
                              child: ContactDialog(contact: contact),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context, 
                            builder: (_) => ConfirmationDialog(
                              title: 'Excluir Favorito', 
                              message: 'Deseja remover ${contact.name} dos favoritos?', 
                              confirmText: 'Excluir',
                              onConfirm: () {
                                context.read<ContactBloc>().add(
                                  DeleteContactEvent(contact: contact),
                                );
                              } 
                            )
                          );
                        },
                      ),
                    ],
                  ),
                );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
