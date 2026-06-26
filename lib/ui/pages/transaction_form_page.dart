import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/bloc/contact/contact_bloc.dart';
import 'package:flutter_banking_ui/bloc/contact/contact_state.dart';
import 'package:flutter_banking_ui/bloc/my_account/my_account_bloc.dart';
import 'package:flutter_banking_ui/bloc/my_account/my_account_event.dart';
import 'package:flutter_banking_ui/bloc/my_account/my_account_state.dart';
import 'package:flutter_banking_ui/bloc/transactions/transaction_bloc.dart';
import 'package:flutter_banking_ui/bloc/transactions/transaction_event.dart';
import 'package:flutter_banking_ui/data/database/app_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionFormPage extends StatefulWidget {
  final bool isDeposit;

  const TransactionFormPage({super.key, required this.isDeposit});

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  int? _selectedContactId;
  

  @override
  void dispose() {
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
  final description = _descriptionController.text.trim();

  final value = double.tryParse(
    _valueController.text.replaceAll(',', '.'),
  );

  if (description.isEmpty) return;

  if(value == null || value <= 0) return;

  final accountState = context.read<MyAccountBloc>().state;

  if(accountState is! MyAccountLoadedState) {
    return;
  }

  if (!widget.isDeposit &&
    value > accountState.account.balance) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Saldo insuficiente'),
    ),
  );
  return;
}

  final transaction = 
    TransactionsCompanion.insert(
      description: description,
      value: value,
      type: widget.isDeposit ? 'income' : 'expense',
      createdAt: DateTime.now(),
      contactId: drift.Value(_selectedContactId),
    );

  context.read<TransactionBloc>().add(
    CreateTransactionEvent(
      transaction: transaction, 
    )
  );

  final account = accountState.account;

  final newBalance = widget.isDeposit
      ? account.balance + value
      : account.balance - value;
      
  context.read<MyAccountBloc>().add(
    UpdateMyAccountEvent(
      account.copyWith(
        balance: newBalance
      )
    )
  );
  Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {
    final title = widget.isDeposit ? 'Receber' : 'Enviar';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if(!widget.isDeposit)
              BlocBuilder<ContactBloc,ContactState>(
                builder: (context, state) {
                  if(state is! ContactLoadedState || state.contacts.isEmpty) {
                    return const SizedBox();
                  }
                  return DropdownButtonFormField<int>(
                    initialValue: _selectedContactId,
                    decoration: const InputDecoration(
                      labelText: 'Favorito (Opcional)',
                      border: OutlineInputBorder(),
                    ),
                    items: state.contacts.map((contact) {
                      return DropdownMenuItem<int>(
                        value: contact.id,
                        child: Text(contact.name)
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedContactId = value;
                      });
                    }
                  );
                }
              ),
              
              const SizedBox(height: 16,),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 16),

            TextField(
              controller: _valueController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Valor',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),

            SizedBox(

              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTransaction, 
                child: Text(
                  widget.isDeposit ? 'Receber' : 'Enviar',
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}

