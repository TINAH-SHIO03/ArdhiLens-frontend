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
    final rawData = (json['data'] as Map?)?.cast<String, dynamic>();

    return ApiEnvelope<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: rawData == null ? null : parser(rawData),
      errors: (json['errors'] as Map?)?.cast<String, dynamic>(),
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
