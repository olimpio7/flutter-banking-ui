import 'dart:io';
import 'package:flutter/material.dart';

class ImageHelper {
  static ImageProvider getImageProvider(String path) {
    if (path.startsWith('assets/')) {
      return AssetImage(path);
    } else {
      return FileImage(File(path));
    }
  }
}
