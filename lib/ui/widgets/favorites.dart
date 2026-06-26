import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../utils/image_helper.dart';

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

  String getInitials(String name) {
    final parts = name.trim().split(' ');

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: imagePath != null
                        ? ImageHelper.getImageProvider(imagePath!)
                        : null,
                    child: imagePath == null ? Text(getInitials(name)) : null,
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