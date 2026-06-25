import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

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
      // Modifique a linha do decoration dentro do seu SoftContainer:
      decoration: BoxDecoration(
        // Se você passar cor manual ele usa, se não, ele descobre se o app está claro ou escuro sozinho!
        color: color ?? AppColors.getContainerColor(context),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
