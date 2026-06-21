import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/ui/pages/manage_favorites_page.dart';
import 'package:flutter_banking_ui/ui/widgets/text_button_action.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/contact/contact_bloc.dart';
import '../../bloc/contact/contact_state.dart';
import '../../bloc/my_account/my_account_bloc.dart';
import '../../bloc/my_account/my_account_event.dart';
import '../../bloc/my_account/my_account_state.dart';
import '../../bloc/transactions/transaction_bloc.dart';
import '../../bloc/transactions/transaction_state.dart';
import '../../data/database/app_database.dart';
import '../widgets/action_button.dart';
import '../widgets/add_favorite_button.dart';
import '../widgets/favorites.dart';
import '../widgets/soft_container.dart';
import '../widgets/transaction_racently.dart';
import 'transactions_history_page.dart';

final TextStyle text = TextStyle(fontSize: 18);

final TextStyle subText = TextStyle(
  fontSize: 15,
  color: const Color(0xFF9E9E9E),
);

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: BlocBuilder<MyAccountBloc, MyAccountState>(
            builder: (context, state) {
              if (state is MyAccountLoadingState) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                );
              }

              if (state is MyAccountNotFoundState) {
                return ElevatedButton(
                  onPressed: () {
                    final newAccount = MyAccountsCompanion.insert(
                      name: 'Olimpio Carvalho',
                      balance: 0.0,
                    );
                    context.read<MyAccountBloc>().add(
                      CreateMyAccountEvent(newAccount),
                    );
                  },
                  child: const Text('Criar Conta'),
                );
              }

              if (state is MyAccountErrorState) {
                return Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                );
              }

              if (state is MyAccountLoadedState) {
                final balanceFormatted = state.account.balance.toStringAsFixed(
                  2,
                );
                final parts = balanceFormatted.split('.');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SoftContainer(
                          padding: EdgeInsets.fromLTRB(1, 1, 12, 1),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(
                                  'assets/images/deel.jpg',
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(right: 8.0)),
                              Text(state.account.name, style: text),
                            ],
                          ),
                        ),
                        SoftContainer(child: Icon(Icons.notifications_none)),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8.0)),
                    Text('Seu Saldo', style: subText),
                    Row(
                      children: [
                        Text(
                          "R\$${parts[0]}.",
                          style: text.copyWith(fontSize: 45),
                        ),
                        Text(parts[1], style: subText.copyWith(fontSize: 45)),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ActionButton(
                              textAction: 'Enviar',
                              icon: Icons.north_east,
                              iconRight: true,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                          ),
                          Expanded(
                            child: ActionButton(
                              textAction: 'Receber',
                              icon: Icons.south_west,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SoftContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Favoritos', style: text),
                                TextButtonAction(
                                  text: 'Gerenciar', 
                                  onPressed: () {
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(
                                        builder:(_) => BlocProvider.value(
                                          value: context.read<ContactBloc>(),
                                          child: const ManageFavoritesPage(),
                                        ) 
                                      )
                                    );
                                  }
                                )
                              ],
                            ),

                            BlocBuilder<ContactBloc, ContactState>(
                              builder: (context, state) {
                                if (state is ContactLoadingState) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (state is ContactErrorState) {
                                  return Text(state.message);
                                }

                                if (state is ContactLoadedState) {
                                  return SizedBox(
                                    height: 85,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.contacts.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index == state.contacts.length) {
                                          return const AddFavoriteButton();
                                        }

                                        final contact = state.contacts[index];

                                        return Favorites(
                                          name: contact.name,
                                          imagePath: contact.avatar,
                                          logoPayment: contact.paymentLogo,
                                        );
                                      },
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),

                            Expanded(
                              child: SoftContainer(
                                color: Colors.grey[100],
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Transações Recentes',
                                          style: text,
                                        ),
                                        TextButtonAction(
                                          text: 'Ver Mais', 
                                          onPressed: (){
                                            Navigator.push(
                                              context, 
                                                MaterialPageRoute(
                                                  builder:(_) => BlocProvider.value(
                                                    value: context.read<TransactionBloc>(),
                                                    child: const TransactionsHistoryPage(),
                                                  ), 
                                                )
                                               );
                                              }
                                          )
                                      ],
                                    ),
                                    BlocBuilder<
                                      TransactionBloc,
                                      TransactionState
                                    >(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                              child: Text(
                                                'Nenhuma Transação encontrada',
                                                textAlign: TextAlign.center,
                                                style: subText,
                                              ),
                                            );
                                          }
                                          return Column(
                                            children: state.transactions.map((
                                              transaction,
                                            ) {
                                              return TransactionsRecently(
                                                namePayment:
                                                    transaction.description,
                                                valuePayment:
                                                    transaction.type ==
                                                        'expense'
                                                    ? '-R\$${transaction.value.toStringAsFixed(2)}'
                                                    : '+R\$${transaction.value.toStringAsFixed(2)}',
                                                detailPayment: transaction
                                                    .createdAt
                                                    .toString(),
                                                icon:
                                                    transaction.type ==
                                                        'expense'
                                                    ? Icons.shopping_cart
                                                    : Icons.attach_money,
                                              );
                                            }).toList(),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
