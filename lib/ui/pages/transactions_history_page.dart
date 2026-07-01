import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/contact/contact_bloc.dart';
import '../../bloc/contact/contact_state.dart';
import '../../bloc/transactions/transaction_bloc.dart';
import '../../bloc/transactions/transaction_event.dart';
import '../../bloc/transactions/transaction_state.dart';
import '../../database/app_database.dart';
import '../../utils/formatters.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/soft_dialog.dart';
import '../widgets/transaction_racently.dart';

class TransactionsHistoryPage extends StatelessWidget {
  const TransactionsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extrato'),
        backgroundColor: Color(0xFFF5F5F7),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionErrorState) {
            return Center(child: Text(state.message));
          }

          if (state is TransactionLoadedState) {
            if (state.transactions.isEmpty) {
              return const Center(child: Text('Nenhuma transação encontrada'));
            }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: state.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = state.transactions.reversed.toList()[index];

                    final formattedValue = AppFormatters.formatCurrency(transaction.value);

                    String? avatar;
                    String? contactName;
                    final contactState = context.read<ContactBloc>().state;
                    if (transaction.contactId != null && contactState is ContactLoadedState) {
                      try {
                        final c = contactState.contacts.firstWhere((c) => c.id == transaction.contactId);
                        avatar = c.avatar;
                        contactName = c.name;
                      } catch (_) {}
                    }

                    return TransactionsRecently(
                      namePayment: transaction.description,
                      valuePayment: transaction.type == 'expense'
                          ? '-$formattedValue'
                          : '+$formattedValue',
                      detailPayment: formatDate(transaction.createdAt),
                      icon: transaction.type == 'expense'
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      avatar: avatar,
                      contactName: contactName,

                      onDelete: () {
                              final pageContext = context;

                              showDialog(
                                context: context,
                                builder: (dialogContext) => ConfirmationDialog(
                                  title: 'Excluir Transação',
                                  message: 'Deseja excluir esta transação?',
                                  confirmText: 'Excluir',
                                  onConfirm: () {
                                    pageContext.read<TransactionBloc>().add(
                                      DeleteTransactionEvent(transaction: transaction),
                                    );
                                  },
                                ),
                              );
                            },

                      onEdit: () {
                              showEditDialog(context, transaction);
                            },
                    );
                  },
                );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void showEditDialog(BuildContext context, Transaction transaction) {
    final descriptionController = TextEditingController(
      text: transaction.description,
    );
    final valueController = TextEditingController(
      text: transaction.value.toString(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return SoftDialog(
          title: 'Editar Transação',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final updatedTransaction = transaction.copyWith(
                  description: descriptionController.text,
                  value:
                      double.tryParse(valueController.text) ??
                      transaction.value,
                );

                context.read<TransactionBloc>().add(
                  UpdateTransactionEvent(transaction: updatedTransaction),
                );

                Navigator.pop(dialogContext);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}

String formatDate(DateTime date) {
  return DateFormat('dd/MM • HH:mm').format(date);
}