import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import 'api_exception.dart';
import 'app_config.dart';
import 'storage_service.dart';
import '../models/parsing.dart';

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
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: _headers(requiresAuth: requiresAuth)),
      );

      return _asMap(response.data);
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
      final response = await _dio.get(
        endpoint,
        options: Options(headers: _headers(requiresAuth: requiresAuth)),
      );

      return _asMap(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? data,
    bool requiresAuth = true,
  }) async {
    final endpoint = _buildUrl(path);

    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        options: Options(headers: _headers(requiresAuth: requiresAuth)),
      );

      return _asMap(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? data,
    bool requiresAuth = true,
  }) async {
    final endpoint = _buildUrl(path);

    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        options: Options(headers: _headers(requiresAuth: requiresAuth)),
      );

      return _asMap(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Map<String, String> _headers({
    required bool requiresAuth,
    bool jsonContentType = true,
  }) {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Accept-Language': _storage.languageCode,
      'X-Locale': _storage.languageCode,
    };

    if (jsonContentType) {
      headers['Content-Type'] = 'application/json';
    }

    if (requiresAuth) {
      final token = _storage.authToken;
      if (token == null || token.isEmpty) {
        throw ApiException(message: 'err_auth_required'.tr);
      }

      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<Map<String, dynamic>> uploadMultipart(
    String path, {
    required FormData formData,
    bool requiresAuth = true,
  }) async {
    final endpoint = _buildUrl(path);

    try {
      // Do not set Content-Type manually — Dio must add the multipart boundary.
      final response = await _dio.post<Map<String, dynamic>>(
        endpoint,
        data: formData,
        options: Options(
          headers: _headers(requiresAuth: requiresAuth, jsonContentType: false),
        ),
      );

      return response.data ?? <String, dynamic>{};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<int>> downloadBytes(
    String path, {
    bool requiresAuth = true,
  }) async {
    final endpoint = _buildUrl(path);

    try {
      final response = await _dio.get<List<int>>(
        endpoint,
        options: Options(
          responseType: ResponseType.bytes,
          headers: _headers(requiresAuth: requiresAuth, jsonContentType: false),
        ),
      );

      return response.data ?? <int>[];
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  String absoluteUrl(String path) => _buildUrl(path);

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
    // Never rewrite a real LAN/public host.
    if (host != '127.0.0.1' && host != 'localhost') {
      return trimmed;
    }

    // Localhost on a physical phone must become the PC LAN IP (not emulator 10.0.2.2).
    return uri
        .replace(host: AppConfig.defaultLanHost, port: AppConfig.defaultPort)
        .toString();
  }

  Map<String, dynamic> _asMap(dynamic data) {
    final map = asStringKeyMap(data);
    if (map == null) {
      throw ApiException(message: 'Invalid server response.');
    }
    return map;
  }
}
