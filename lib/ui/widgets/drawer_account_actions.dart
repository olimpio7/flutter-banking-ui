
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../bloc/my_account/my_account_bloc.dart';
import '../../bloc/my_account/my_account_event.dart';
import '../../bloc/my_account/my_account_state.dart';
import 'user_avatar.dart';

class DrawerAccountActions {
  static void showEditProfileDialog(BuildContext context) {
    final bloc = context.read<MyAccountBloc>();
    if (bloc.state is! MyAccountLoadedState) return;
    final account = (bloc.state as MyAccountLoadedState).account;

    final nameController = TextEditingController(text: account.name);
    final picker = ImagePicker();

    String? selectedPath = account.imagePath;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Editar Perfil'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserAvatar(
                    name: nameController.text.isEmpty ? account.name : nameController.text,
                    imagePath: selectedPath,
                    radius: 45,
                  ),
                  
                  TextButton.icon(
                    onPressed: () async {
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setDialogState(() {
                          selectedPath = image.path;
                        });
                      }
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Alterar Foto'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Titular',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newName = nameController.text.trim();
                    if (newName.isEmpty) return;

                    final updatedAccount = account.copyWith(
                      name: newName,
                      imagePath: drift.Value<String?>(selectedPath),
                    );

                    bloc.add(UpdateMyAccountEvent(updatedAccount));

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}