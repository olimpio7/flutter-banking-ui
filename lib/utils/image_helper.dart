import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageHelper {
  static ImageProvider getImageProvider(String path) {
    if (path.startsWith('assets/')) {
      return AssetImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  static Future<String> saveImagePermanently(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final avatarsDir = Directory(p.join(dir.path, 'avatars'));
    
    if (!await avatarsDir.exists()) {
      await avatarsDir.create(recursive: true);
    }
    
    final fileName = '${DateTime.now().microsecondsSinceEpoch}_${p.basename(sourcePath)}';
    final newPath = p.join(avatarsDir.path, fileName);
    
    final newFile = await File(sourcePath).copy(newPath);
    return newFile.path;
  }
}
