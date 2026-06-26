import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/bloc/contact/contact_bloc.dart';
import 'package:flutter_banking_ui/bloc/contact/contact_state.dart';
import 'package:flutter_banking_ui/bloc/my_account/my_account_bloc.dart';
import 'package:flutter_banking_ui/bloc/my_account/my_account_state.dart';
import 'package:flutter_banking_ui/bloc/transactions/transaction_bloc.dart';
import 'package:flutter_banking_ui/bloc/transactions/transaction_event.dart';
import 'package:flutter_banking_ui/data/database/app_database.dart';
import 'package:flutter_banking_ui/utils/formatters.dart';
import 'package:flutter_banking_ui/utils/image_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/app_theme.dart';
import '../widgets/favorites.dart';
import '../widgets/soft_container.dart';

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
  Contact? _selectedContact;

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedContact != null) {
      _selectedContact = widget.preSelectedContact;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    final description = _descriptionController.text.trim();

    String cleanString = _valueController.text.replaceAll('R\$', '').replaceAll('.', '').replaceAll(',', '.').trim();
    final value = double.tryParse(cleanString);

    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, informe um valor maior que zero.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha o título.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final accountState = context.read<MyAccountBloc>().state;
    if(accountState is! MyAccountLoadedState) return;

    if (!widget.isDeposit && value > accountState.account.balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo insuficiente')),
      );
      return;
    }

    final transaction = TransactionsCompanion.insert(
      description: description,
      value: value,
      type: widget.isDeposit ? 'income' : 'expense',
      createdAt: DateTime.now(),
      contactId: drift.Value(_selectedContact?.id),
    );

    context.read<TransactionBloc>().add(CreateTransactionEvent(transaction: transaction));
    Navigator.pop(context);
  }

  List<String> get _quickTags {
    final name = _selectedContact?.name.split(' ').first;
    if (widget.isDeposit) {
      return [
        if (name != null) 'Pix de $name',
        'Salário',
        'Reembolso',
        'Venda',
        'Cashback',
        'Depósito',
      ];
    } else {
      return [
        if (name != null) 'Pix para $name',
        'Mercado',
        'Aluguel',
        'Boleto',
        'Comida',
        'Transporte',
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  const SizedBox(width: 44), // To balance the back button width
                ],
              ),
              const SizedBox(height: 32),

              // Favorites Selector
              if (_selectedContact != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SoftContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: _selectedContact!.avatar != null 
                                ? ImageHelper.getImageProvider(_selectedContact!.avatar!)
                                : null,
                            child: _selectedContact!.avatar == null
                                ? Text(_selectedContact!.name[0], style: const TextStyle(color: Colors.black54))
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_selectedContact!.name, style: text.copyWith(fontWeight: FontWeight.bold)),
                              Text(widget.isDeposit ? 'Recebendo de' : 'Enviando para', style: subText.copyWith(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (widget.preSelectedContact == null) // Can only close if not forced
                      GestureDetector(
                        onTap: () => setState(() => _selectedContact = null),
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
                         return const SizedBox(); // No contacts
                      }
                      return SizedBox(
                        height: 95,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.contacts.length,
                          itemBuilder: (context, index) {
                            final contact = state.contacts[index];
                            return GestureDetector(
                              onTap: () => setState(() => _selectedContact = contact),
                              child: Favorites(
                                name: contact.name,
                                imagePath: contact.avatar,
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),

              const Spacer(),

              // Huge Value Input
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

              // Quick Tags (Chips)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickTags.map((tag) {
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

              // Description Input
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Título (Ex: Pizza, Aluguel)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: _saveTransaction,
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
    );
  }
}

