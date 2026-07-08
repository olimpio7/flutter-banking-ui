
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../viewmodels/my_account/my_account_bloc.dart';
import '../../viewmodels/my_account/my_account_event.dart';
import '../../viewmodels/my_account/my_account_state.dart';
import 'soft_dialog.dart';
import 'avatar.dart';
import '../../utils/image_helper.dart';

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
            return SoftDialog(
              title: 'Editar Perfil',
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          final permanentPath = await ImageHelper.saveImagePermanently(image.path);
                          setDialogState(() {
                            selectedPath = permanentPath;
                          });
                        }
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          UserAvatar(
                            name: nameController.text.isEmpty ? account.name : nameController.text,
                            imagePath: selectedPath,
                            radius: 45,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
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