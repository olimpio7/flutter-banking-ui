import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'soft_container.dart';

class ActionButton extends StatelessWidget {
  final String textAction;
  final IconData icon;
  final bool iconRight;
  final VoidCallback? onTap;

  const ActionButton({
    super.key,
    required this.textAction,
    required this.icon,
    this.iconRight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SoftContainer(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: iconRight
              ? [Text(textAction, style: text), SizedBox(width: 6), Icon(icon)]
              : [Icon(icon), SizedBox(width: 6), Text(textAction, style: text)],
        ),
      ),
    );
  }
}