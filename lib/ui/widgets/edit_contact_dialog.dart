import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/contact/contact_bloc.dart';
import '../../bloc/contact/contact_event.dart';
import '../../database/app_database.dart';
import '../../utils/image_helper.dart';
import 'soft_dialog.dart';
import 'package:drift/drift.dart' as drift;

class ContactDialog extends StatefulWidget {
  final Contact? contact;

  const ContactDialog({super.key, this.contact});

  @override
  State<ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
  late TextEditingController _nameController;
  String? _selectedAvatar;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedAvatar = image.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _selectedAvatar = widget.contact?.avatar;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;

    return SoftDialog(
      title: isEditing ? 'Editar Favorito' : 'Novo Favorito',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _selectedAvatar != null
                        ? ImageHelper.getImageProvider(_selectedAvatar!)
                        : null,
                    child: _selectedAvatar == null
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
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
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isNotEmpty) {
              if (isEditing) {
                context.read<ContactBloc>().add(
                  UpdateContactEvent(
                    contact: widget.contact!.copyWith(
                      name: name,
                      avatar: drift.Value(_selectedAvatar),
                    ),
                  ),
                );
              } else {
                context.read<ContactBloc>().add(
                  CreateContactEvent(
                    contact: ContactsCompanion.insert(
                      name: name,
                      avatar: drift.Value(_selectedAvatar),
                    ),
                  ),
                );
              }
              Navigator.pop(context);
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
