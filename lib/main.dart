import 'package:flutter/material.dart';
import 'package:flutter_banking_ui/ui/initial_page.dart';

void main() {
  runApp(const MainApp());
}

const TextStyle text = TextStyle(fontSize: 18);

const TextStyle subText = TextStyle(
  fontSize: 15,
  color: Color(0xFF9E9E9E),
);

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