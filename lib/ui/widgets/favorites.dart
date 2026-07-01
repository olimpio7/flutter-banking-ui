import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'avatar.dart';

class Favorites extends StatelessWidget {
  final String name;
  final String? imagePath;
  final String? logoPayment;
  final VoidCallback? onTap;

  const Favorites({
    super.key,
    required this.name,
    this.imagePath,
    this.logoPayment, 
    this.onTap,
  });

  String getDisplayName(String name) {
    final firstName = name.trim().split(' ').first;

    if (firstName.length > 8) {
      return '${firstName.substring(0, 8)}...';
    }
    return firstName;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                  UserAvatar(
                    name: name,
                    imagePath: imagePath,
                    radius: 25,
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
      ),
    );
  }
}