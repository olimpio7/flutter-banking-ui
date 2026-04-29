import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  SoftContainer(
                    padding: EdgeInsets.fromLTRB(4, 4, 8, 4),
                    child: Row(
                      children: [
                        CircleAvatar(),
                        Text('Olimpio Carvalho'),
                     ],
                    )
                  )
                ],
              )
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

  const SoftContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}