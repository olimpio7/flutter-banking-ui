import 'package:flutter/material.dart';
import '../../utils/image_helper.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final String? imagePath;
  final double radius;

  const UserAvatar({
    super.key,
    required this.name,
    this.imagePath,
    this.radius = 25,
  });

  String getInitials(String name) {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: imagePath != null
          ? ImageHelper.getImageProvider(imagePath!)
          : null,
      child: imagePath == null
          ? Text(
              getInitials(name),
              style: TextStyle(
                fontSize: radius * 0.6,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}
