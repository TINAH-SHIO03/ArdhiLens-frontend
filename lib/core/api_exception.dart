import 'package:dio/dio.dart';

import '../models/parsing.dart';

class ApiException implements Exception {
  ApiException({required this.message, this.statusCode, this.errors});

  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  factory ApiException.fromDio(DioException exception) {
    final responseData = exception.response?.data;
    final map = asStringKeyMap(responseData);

    String message;
    if (map != null) {
      message = asString(map['message'], fallback: 'Request failed.');
      final validation = asStringKeyMap(map['errors'])?['validation'];
      if (validation is Map && validation.isNotEmpty) {
        final first = validation.values.first;
        if (first is List && first.isNotEmpty) {
          message = first.first.toString();
        } else if (first != null) {
          message = first.toString();
        }
      }
    } else if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout) {
      message = 'Connection timed out. Check Wi‑Fi and API URL.';
    } else if (exception.type == DioExceptionType.connectionError) {
      message =
          'Cannot reach server. Use http://192.168.1.7:8000 on the same Wi‑Fi.';
    } else {
      message = exception.message ?? 'Network request failed.';
    }

    return ApiException(
      message: message,
      statusCode: exception.response?.statusCode,
      errors: map == null ? null : asStringKeyMap(map['errors']),
    );
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
