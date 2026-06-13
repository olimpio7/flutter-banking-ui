import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/bloc/my_account/my_account_bloc.dart';
import 'package:flutter_banking_ui/bloc/my_account/my_account_state.dart';
import 'package:flutter_banking_ui/data/database/app_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/my_account/my_account_event.dart';

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
                final balanceFormatted = state.account.balance.toStringAsFixed(2);
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
                        Text(
                          parts[1], 
                          style: subText.copyWith(fontSize: 45)
                        ),
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
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 4.0,
                            ),
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
                    SoftContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Enviar Novamente', style: text),
                          Row(
                            children: [
                              Expanded(
                                child: Transactions(
                                  name: 'Kate',
                                  imagePath: 'assets/images/Kate.jpg',
                                  logoPayment: 'assets/images/visa.jpg',
                                ),
                              ),
                              Expanded(
                                child: Transactions(
                                  name: 'Dave',
                                  imagePath: 'assets/images/Dave.jpg',
                                  logoPayment: 'assets/images/visa.jpg',
                                ),
                              ),
                              Expanded(
                                child: Transactions(
                                  name: 'Jackie',
                                  imagePath: 'assets/images/Jackie.jpg',
                                  logoPayment: 'assets/images/paypal.jpg',
                                ),
                              ),
                              Expanded(
                                child: Transactions(
                                  name: 'Tom',
                                  imagePath: 'assets/images/Tom.jpg',
                                  logoPayment: 'assets/images/mastercard.jpg',
                                ),
                              ),
                              Expanded(
                                child: Transactions(
                                  name: 'Felca',
                                  imagePath: 'assets/images/Felca.jpg',
                                  logoPayment: 'assets/images/paypal.jpg',
                                ),
                              ),
                            ],
                          ),
                          SoftContainer(
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
                                TransactionsRecently(
                                  icon: Icons.shopping_cart,
                                  namePayment: 'Frutaria',
                                  valuePayment: '-\$189.0',
                                  detailPayment: '23 Jan • 3:40 PM',
                                ),
                                TransactionsRecently(
                                  imagePath2: 'assets/images/Kate.jpg',
                                  namePayment: 'kate',
                                  valuePayment: '+\$250.0',
                                  detailPayment: '22 Jan • 5:33 PM',
                                ),
                                TransactionsRecently(
                                  imagePath2: 'assets/images/Felca.jpg',
                                  namePayment: 'Felca',
                                  valuePayment: '+\$300.0',
                                  detailPayment: '21 Jan • 6:19 PM',
                                ),
                                TransactionsRecently(
                                  icon: Icons.apple,
                                  namePayment: 'App Store',
                                  valuePayment: '-\$24.99',
                                  detailPayment: '20 Jan • 1:22 PM',
                                ),
                              ],
                            ),
                          ),
                        ],
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

class Transactions extends StatelessWidget {
  final String name;
  final String imagePath;
  final String? logoPayment;

  const Transactions({
    super.key,
    required this.name,
    required this.imagePath,
    this.logoPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(radius: 25, backgroundImage: AssetImage(imagePath)),
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
        Text(name, style: text),
      ],
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
