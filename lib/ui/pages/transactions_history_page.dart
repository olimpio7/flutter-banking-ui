import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/ui/pages/initial_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/transactions/transaction_bloc.dart';
import '../../bloc/transactions/transaction_state.dart';
import '../widgets/transaction_racently.dart';

class TransactionsHistoryPage extends StatelessWidget {
  const TransactionsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todas as Transações'),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {

          if (state is TransactionLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TransactionErrorState) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is TransactionLoadedState) {

            if (state.transactions.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhuma transação encontrada',
                ),
              );
            }

            return ListView.builder(
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {

                final transaction =
                    state.transactions.reversed.toList()[index];

                return TransactionsRecently(
                  namePayment: transaction.description,
                  valuePayment:
                      transaction.type == 'expense'
                          ? '-R\$${transaction.value.toStringAsFixed(0)}'
                          : '+R\$${transaction.value.toStringAsFixed(0)}',
                  detailPayment:
                      formatDate(transaction.createdAt),
                  icon:
                      transaction.type == 'expense'
                          ? Icons.shopping_cart
                          : Icons.attach_money,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}