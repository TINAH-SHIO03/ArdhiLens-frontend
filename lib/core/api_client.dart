import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'api_exception.dart';
import 'storage_service.dart';

class ApiClient {
  ApiClient(this._storage) {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 45),
        receiveTimeout: const Duration(seconds: 45),
      ),
    );
  }

  final StorageService _storage;
  late final Dio _dio;

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    bool requiresAuth = true,
  }) async {
    final endpoint = _buildUrl(path);

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        endpoint,
        data: data,
        options: Options(headers: _headers(requiresAuth: requiresAuth)),
      );

      return response.data ?? <String, dynamic>{};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    bool requiresAuth = true,
  }) async {
    final endpoint = _buildUrl(path);

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        endpoint,
        options: Options(headers: _headers(requiresAuth: requiresAuth)),
      );

      return response.data ?? <String, dynamic>{};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Map<String, String> _headers({required bool requiresAuth}) {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Accept-Language': _storage.languageCode,
      'X-Locale': _storage.languageCode,
    };

    if (requiresAuth) {
      final token = _storage.authToken;
      if (token == null || token.isEmpty) {
        throw ApiException(message: 'Authentication required.');
      }

      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  String _buildUrl(String path) {
    final base = _storage.baseUrl;
    if (base == null || base.isEmpty) {
      throw ApiException(message: 'Base URL missing in settings.');
    }

    final normalizedBase = _normalizeBaseUrl(base);
    final apiBase = normalizedBase.endsWith('/api')
        ? normalizedBase
        : '$normalizedBase/api';

    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return '$apiBase$normalizedPath';
  }

  String _normalizeBaseUrl(String value) {
    final trimmed = value.endsWith('/')
        ? value.substring(0, value.length - 1)
        : value;

    if (!GetPlatform.isAndroid) {
      return trimmed;
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null) {
      return trimmed;
    }

    final host = uri.host.toLowerCase();
    if (host != '127.0.0.1' && host != 'localhost') {
      return trimmed;
    }

    return uri.replace(host: '10.0.2.2').toString();
  }
}
