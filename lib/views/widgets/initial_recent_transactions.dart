import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/contact/contact_bloc.dart';
import '../../viewmodels/contact/contact_state.dart';
import '../../viewmodels/transactions/transaction_bloc.dart';
import '../../viewmodels/transactions/transaction_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../pages/transactions_history_page.dart';
import 'soft_container.dart';
import 'text_button_action.dart';
import 'transaction_racently.dart';

class InitialRecentTransactions extends StatelessWidget {
  const InitialRecentTransactions({super.key});

  String formatDate(DateTime date) {
    return DateFormat('dd/MM • HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return SoftContainer(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transações Recentes',
                style: text,
              ),
              TextButtonAction(
                text: 'Ver Mais',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<TransactionBloc>(),
                        child: const TransactionsHistoryPage(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is TransactionErrorState) {
                return Text(
                  state.message,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                );
              }

              if (state is TransactionLoadedState) {
                if (state.transactions.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    child: Text(
                      'Nenhuma Transação encontrada',
                      textAlign: TextAlign.center,
                      style: subText,
                    ),
                  );
                }
                final screenHeight = MediaQuery.of(context).size.height;
                final int takeCount = screenHeight < 700 ? 3 : 5;
                final recentTransactions = state.transactions.reversed.take(takeCount).toList();

                return BlocBuilder<ContactBloc, ContactState>(
                  builder: (context, contactState) {
                    return Column(
                      children: recentTransactions.map((transaction) {
                        final formattedValue = AppFormatters.formatCurrency(transaction.value);
                        
                        String? avatar;
                        String? contactName;
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
                          detailPayment: formatDate(
                            transaction.createdAt,
                          ),
                          icon: transaction.type == 'expense'
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          avatar: avatar,
                          contactName: contactName,
                        );
                      }).toList(),
                    );
                  }
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
