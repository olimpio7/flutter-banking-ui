import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'user_avatar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}