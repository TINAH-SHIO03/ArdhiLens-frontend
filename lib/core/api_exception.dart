import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException({required this.message, this.statusCode, this.errors});

  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  factory ApiException.fromDio(DioException exception) {
    final responseData = exception.response?.data;
    final message = responseData is Map<String, dynamic>
        ? (responseData['message'] as String? ?? 'Request failed.')
        : (exception.message ?? 'Network request failed.');

    final errors = responseData is Map<String, dynamic>
        ? (responseData['errors'] as Map?)?.cast<String, dynamic>()
        : null;

    return ApiException(
      message: message,
      statusCode: exception.response?.statusCode,
      errors: errors,
    );
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
