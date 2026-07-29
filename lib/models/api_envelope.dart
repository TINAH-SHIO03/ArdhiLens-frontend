import 'parsing.dart';

class ApiEnvelope<T> {
  ApiEnvelope({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
    required this.timestamp,
  });

  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final DateTime timestamp;

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> data) parser,
  ) {
    final rawData = asStringKeyMap(json['data']);

    return ApiEnvelope<T>(
      success: asBool(json['success']) ?? false,
      message: asString(json['message']),
      data: rawData == null ? null : parser(rawData),
      errors: asStringKeyMap(json['errors']),
      timestamp:
          DateTime.tryParse(asString(json['timestamp'])) ?? DateTime.now(),
    );
  }
}
