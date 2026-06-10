import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/ui/initial_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roble'),
      home: InitialPage()
    );
  }
}