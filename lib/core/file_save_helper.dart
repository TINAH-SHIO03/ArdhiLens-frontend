import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Saves files to the public Downloads/ArdhiLens folder visible in file managers.
class FileSaveHelper {
  static const _channel = MethodChannel('ardhilens/storage');

  static Future<Directory> downloadsFolder() async {
    if (Platform.isAndroid) {
      final pubDir = Directory('/storage/emulated/0/Download/ArdhiLens');
      try {
        if (!await pubDir.exists()) {
          await pubDir.create(recursive: true);
        }
        // Test write access
        final test = File('${pubDir.path}/.access_test');
        await test.writeAsString('ok');
        await test.delete();
        return pubDir;
      } catch (_) {
        // Fall back to app-specific external storage
        final extDir = await getExternalStorageDirectory();
        if (extDir != null) {
          final fallback = Directory('${extDir.path}/ArdhiLens');
          if (!await fallback.exists()) {
            await fallback.create(recursive: true);
          }
          return fallback;
        }
      }
    }

    Directory? dir = await getDownloadsDirectory();
    dir ??= await getApplicationDocumentsDirectory();

    final folder = Directory('${dir.path}/ArdhiLens');
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    return folder;
  }

  static String sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[^\w.\-]+'), '_');
  }

  static Future<File> saveBytes({
    required List<int> bytes,
    required String fileName,
  }) async {
    final folder = await downloadsFolder();
    final safe = sanitizeFileName(fileName);
    final file = File('${folder.path}/$safe');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static String displayPath(File file) {
    final path = file.path;
    const marker = '/storage/emulated/0/';
    final index = path.indexOf(marker);
    if (index >= 0) {
      return path.substring(index + marker.length);
    }
    // Show last meaningful segments for app-private paths
    final parts = path.split('/');
    if (parts.length > 3) {
      return parts.sublist(parts.length - 3).join('/');
    }
    return path;
  }
}
