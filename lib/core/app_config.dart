import 'dart:io';

import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _envApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// Live API on VM (HTTPS via Caddy).
  static const String liveApiUrl = 'https://ardhilens.dickens-manyama.tech';
  static const String defaultLanHost = '192.168.1.7';
  static const int defaultPort = 8000;

  static String get apiBaseUrl {
    if (_envApiBaseUrl.trim().isNotEmpty) {
      return _normalize(_envApiBaseUrl);
    }

    return liveApiUrl;
  }

  /// True when a stored URL is emulator/local-only and will fail on a real phone.
  static bool isUnreachableOnPhysicalDevice(String? url) {
    if (url == null || url.trim().isEmpty) return true;
    final host = Uri.tryParse(url.trim())?.host.toLowerCase() ?? '';
    return host == '10.0.2.2' ||
        host == '127.0.0.1' ||
        host == 'localhost' ||
        host.isEmpty;
  }

  static String _normalize(String value) {
    final trimmed = value.trim();
    if (trimmed.endsWith('/')) {
      return trimmed.substring(0, trimmed.length - 1);
    }

    return trimmed;
  }
}
