import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/contact/contact_bloc.dart';
import '../../bloc/contact/contact_state.dart';
import '../../bloc/my_account/my_account_bloc.dart';
import '../../bloc/my_account/my_account_event.dart';
import '../../bloc/my_account/my_account_state.dart';
import '../../bloc/transactions/transaction_bloc.dart';
import '../../bloc/transactions/transaction_state.dart';
import '../../data/database/app_database.dart';
import 'add_favorites_page.dart';

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
                                TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    overlayColor: WidgetStateProperty.all(
                                      Colors.transparent,
                                    ),
                                    padding: WidgetStateProperty.all(
                                      EdgeInsets.zero,
                                    ),
                                    foregroundColor:
                                        WidgetStateProperty.resolveWith((
                                          states,
                                        ) {
                                          if (states.contains(
                                            WidgetState.pressed,
                                          )) {
                                            return Colors.blue;
                                          }
                                          return const Color(0xFF9E9E9E);
                                        }),
                                  ),
                                  child: Text('Gerenciar'),
                                ),
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
                                        Text('Transações Recentes', style: text),
                                        Text('Ver mais', style: subText),
                                      ],
                                    ),
                                    BlocBuilder<TransactionBloc,TransactionState>(
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
                                                valuePayment: transaction.type == 'expense'
                                                    ? '-R\$${transaction.value.toStringAsFixed(2)}'
                                                    : '+R\$${transaction.value.toStringAsFixed(2)}',
                                                detailPayment: transaction
                                                    .createdAt
                                                    .toString(),
                                                icon:
                                                    transaction.type == 'expense'
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

class ActionButton extends StatelessWidget {
  final String textAction;
  final IconData icon;
  final bool iconRight;

  const ActionButton({
    super.key,
    required this.textAction,
    required this.icon,
    this.iconRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return SoftContainer(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[100],
      boxShadow: [BoxShadow(color: Colors.grey[300]!, spreadRadius: 0.5)],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: iconRight
            ? [Text(textAction, style: text), SizedBox(width: 6), Icon(icon)]
            : [Icon(icon), SizedBox(width: 6), Text(textAction, style: text)],
      ),
    );
  }
}

class Favorites extends StatelessWidget {
  final String name;
  final String? imagePath;
  final String? logoPayment;

  const Favorites({
    super.key,
    required this.name,
    this.imagePath,
    this.logoPayment,
  });

  String getDisplayName(String name) {
    final firstName = name.trim().split(' ').first;

    if (firstName.length > 10) {
      return '${firstName.substring(0, 10)}...';
    }
    return firstName;
  }

  String getInitials(String name) {
    final parts = name.trim().split(' ');

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: imagePath != null
                      ? AssetImage(imagePath!)
                      : null,
                  child: imagePath == null ? Text(getInitials(name)) : null,
                ),
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                    image: logoPayment != null
                        ? DecorationImage(image: AssetImage(logoPayment!))
                        : null,
                  ),
                ),
              ],
            ),
          ),

          Text(
            getDisplayName(name),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: subText,
          ),
        ],
      ),
    );
  }
}

class SoftContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final Color? color;
  final List<BoxShadow>? boxShadow;

  const SoftContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = 30,
    this.color,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}

class TransactionsRecently extends StatelessWidget {
  final String namePayment;
  final String valuePayment;
  final String detailPayment;
  final String? imagePath2;
  final IconData? icon;

  const TransactionsRecently({
    super.key,
    required this.namePayment,
    required this.valuePayment,
    required this.detailPayment,
    this.imagePath2,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            backgroundImage: imagePath2 != null
                ? AssetImage(imagePath2!)
                : null,
            child: (imagePath2 == null)
                ? Icon(icon ?? Icons.attach_money, color: Colors.black54)
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(namePayment, style: text),
                Text(detailPayment, style: subText),
              ],
            ),
          ),


          Text(
            valuePayment,
            style: subText.copyWith(
              color: valuePayment.startsWith('-')
                  ? Colors.red
                  : Colors.green[800],
            ),
          ),
        ],
      ),
    );
  }
}

class AddFavoriteButton extends StatelessWidget {
  const AddFavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: BoxBorder.all(color: Color(0xFF9E9E9E), width: .2),
          ),

          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ContactBloc>(),
                    child: const AddFavoritePage(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ),
        const SizedBox(height: 4),
        Text('Novo', style: subText),
      ],
    );
  }
}
