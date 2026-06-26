import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/bloc/bank_mode/bank_mode_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/transactions/transaction_bloc.dart';
import '../../bloc/transactions/transaction_event.dart';
import '../../bloc/transactions/transaction_state.dart';
import '../../data/database/app_database.dart';
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

            return BlocBuilder<BankModeCubit, bool>(
              builder: (context, isBankModeOn) {
                return ListView.builder(
                  itemCount: state.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = state.transactions.reversed
                        .toList()[index];

                    final showActions = !isBankModeOn;
                    final formattedValue = AppFormatters.formatCurrency(transaction.value);

                    return TransactionsRecently(
                      namePayment: transaction.description,
                      valuePayment: transaction.type == 'expense'
                          ? '-$formattedValue'
                          : '+$formattedValue',
                      detailPayment: formatDate(transaction.createdAt),
                      icon: transaction.type == 'expense'
                          ? Icons.shopping_cart
                          : Icons.attach_money,

                      onDelete: showActions
                          ? () {
                              final pageContext = context;

                              if (transaction.contactId != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Não foi possível excluir: existe um contato vinculado a esta transação',
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }

                              showDialog(
                                context: context,
                                builder: (dialogContext) => ConfirmationDialog(
                                  title: 'Excluir Transação',
                                  message: 'Deseja remover esta transação do histórico?',
                                  confirmText: 'Excluir',
                                  onConfirm: () {
                                    pageContext.read<TransactionBloc>().add(
                                      DeleteTransactionEvent(transaction: transaction),
                                    );
                                  },
                                ),
                              );
                            }
                          : null,

                      onEdit: showActions
                          ? () {
                              _showEditDialog(context, transaction);
                            }
                          : null,
                    );
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

  void _showEditDialog(BuildContext context, Transaction transaction) {
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