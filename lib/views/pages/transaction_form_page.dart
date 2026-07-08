import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/viewmodels/contact/contact_bloc.dart';
import 'package:flutter_banking_ui/viewmodels/contact/contact_state.dart';
import 'package:flutter_banking_ui/viewmodels/transactions/transaction_bloc.dart';
import 'package:flutter_banking_ui/viewmodels/transactions/transaction_event.dart';
import 'package:flutter_banking_ui/viewmodels/transactions/transaction_state.dart';
import 'package:flutter_banking_ui/data/app_database.dart';
import 'package:flutter_banking_ui/utils/formatters.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/app_theme.dart';
import '../widgets/favorites.dart';
import '../widgets/soft_container.dart';
import '../widgets/avatar.dart';

class TransactionFormPage extends StatefulWidget {
  final bool isDeposit;
  final Contact? preSelectedContact;

  const TransactionFormPage({super.key, required this.isDeposit, this.preSelectedContact});

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController(text: 'R\$ 0,00');
  Contact? selectedContact;

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedContact != null) {
      selectedContact = widget.preSelectedContact;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionValidationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else if (state is TransactionSubmitSuccess) {
            Navigator.pop(context);
          }
        },
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const SoftContainer(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                  Text(
                    widget.isDeposit ? 'Receber' : 'Enviar',
                    style: text.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
              const SizedBox(height: 32),

              if (selectedContact != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SoftContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          UserAvatar(
                            name: selectedContact!.name,
                            imagePath: selectedContact!.avatar,
                            radius: 20,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(selectedContact!.name, style: text.copyWith(fontWeight: FontWeight.bold)),
                              Text(widget.isDeposit ? 'Receber de' : 'Enviando para', style: subText.copyWith(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (widget.preSelectedContact == null)
                      GestureDetector(
                        onTap: () => setState(() => selectedContact = null),
                        child: const SoftContainer(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.close, size: 16),
                        ),
                      ),
                  ],
                )
              else
                BlocBuilder<ContactBloc, ContactState>(
                  builder: (context, state) {
                    if (state is ContactLoadedState) {
                      if (state.contacts.isEmpty) {
                         return const SizedBox();
                      }
                      return SoftContainer(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                              child: Text('Favoritos', style: text.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                            ),
                            SizedBox(
                              height: 95,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.contacts.length,
                                itemBuilder: (context, index) {
                                  final contact = state.contacts[index];
                                  return Favorites(
                                    name: contact.name,
                                    imagePath: contact.avatar,
                                    onTap: () => setState(() => selectedContact = contact),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),

              const Spacer(),

              TextField(
                controller: _valueController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [CurrencyInputFormatter()],
                textAlign: TextAlign.center,
                style: text.copyWith(fontSize: 48, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),

              const Spacer(),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: TransactionBloc.buildQuickTags(
                    isDeposit: widget.isDeposit,
                    contactFirstName: selectedContact?.name.split(' ').first,
                  ).map((tag) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        backgroundColor: Theme.of(context).brightness == Brightness.dark 
                            ? const Color(0xFF27272A) // containerDark equivalent
                            : Colors.grey[200],
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        label: Text(tag, style: text.copyWith(fontSize: 12)),
                        onPressed: () {
                          _descriptionController.text = tag;
                          _descriptionController.selection = TextSelection.fromPosition(
                            TextPosition(offset: tag.length),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    context.read<TransactionBloc>().add(
                      SubmitTransactionEvent(
                        description: _descriptionController.text,
                        rawValue: _valueController.text,
                        isDeposit: widget.isDeposit,
                        contactId: selectedContact?.id,
                      ),
                    );
                  },
                  child: Text(
                    widget.isDeposit ? 'Receber Dinheiro' : 'Enviar Dinheiro',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

