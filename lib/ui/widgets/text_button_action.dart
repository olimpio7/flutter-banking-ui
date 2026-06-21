import 'package:flutter/material.dart';

class TextButtonAction extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const TextButtonAction({super.key, required this.text, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        // overlayColor: WidgetStateProperty.all(
        //   Colors.transparent,
        // ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 2),
        ),
        // foregroundColor: WidgetStateProperty.resolveWith((states) {
        //   if (states.contains(WidgetState.pressed)) {
        //     return Colors.blue;
        //   }
        //   return Color(0xFF9E9E9E);
        // })
      ),
      child: Text(text,
        style: TextStyle(
          color: color ?? const Color(0xFF9E9E9E),
        ),
      )

      );
  }
}