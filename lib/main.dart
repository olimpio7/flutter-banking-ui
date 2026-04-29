import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SoftContainer(
                    padding: EdgeInsets.fromLTRB(4, 4, 8, 4),
                    child: Row(
                      children: [CircleAvatar(), Text('Olimpio Carvalho')],
                    ),
                  ),
                  SoftContainer(child: Icon(Icons.notifications_none_sharp)),
                ],
              ),
              Text('Your Balance'),
              Text("\$9,891,00"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SoftContainer(child: Text('Send')),
                  SoftContainer(child: Text('Receive')),
                ],
              ),
              SoftContainer(
                child: Column(
                  children: [
                    Text('Send Again'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(),
                        CircleAvatar(),
                        CircleAvatar(),
                        CircleAvatar(),
                        CircleAvatar(),
                      ],
                    ),
                    SoftContainer(
                      color: Colors.grey[100],
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Recently Transactions'),
                              Text('See more'),
                            ],
                          ),
                          Transactions(
                            namePayment: 'Netflix',
                            valuePayment: '-\$15,00',
                            detailPayment: 'Today',
                          ),
                          Transactions(namePayment: 'kioda', valuePayment: '-\$50,00', detailPayment: 'Yesterday'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SoftContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final Color? color;

  const SoftContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}

class Transactions extends StatelessWidget {
  final String namePayment;
  final String valuePayment;
  final String detailPayment;

  const Transactions({
    super.key,
    required this.namePayment,
    required this.valuePayment,
    required this.detailPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          CircleAvatar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(namePayment),
              Text(detailPayment)
              ]
            ),
          ),
          Text(valuePayment),
        ],
      ),
    );
  }
}
