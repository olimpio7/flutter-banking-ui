import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/contact/contact_bloc.dart';
import '../../bloc/contact/contact_event.dart';
import '../../data/database/app_database.dart';

class AddFavoritePage extends StatefulWidget {
  final Contact? contactToEdit;

  const AddFavoritePage({super.key, this.contactToEdit});

  @override
  State<AddFavoritePage> createState() => _AddFavoritePageState();
}

class _AddFavoritePageState extends State<AddFavoritePage> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contactToEdit != null) {
      _nameController.text = widget.contactToEdit!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactToEdit == null ? 'Adicionar Favorito' : 'Editar Favorito'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();

                if (name.isEmpty) return;

                if (widget.contactToEdit == null) {
                  context.read<ContactBloc>().add(
                    CreateContactEvent(
                      contact: ContactsCompanion.insert(name: name),
                    ),
                  );
                } else {
                  context.read<ContactBloc>().add(
                    UpdateContactEvent(
                      contact: widget.contactToEdit!.copyWith(name: name),
                    ),
                  );
                }

                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
