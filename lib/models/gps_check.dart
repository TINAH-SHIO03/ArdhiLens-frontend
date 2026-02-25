import 'parsing.dart';

class GpsCheck {
  GpsCheck({
    required this.passed,
    required this.distanceMeters,
    required this.allowedDistanceMeters,
    required this.submittedLatitude,
    required this.submittedLongitude,
    required this.verifiedAt,
  });

  final bool passed;
  final double? distanceMeters;
  final double? allowedDistanceMeters;
  final double? submittedLatitude;
  final double? submittedLongitude;
  final DateTime? verifiedAt;

  factory GpsCheck.fromJson(Map<String, dynamic> json) {
    return GpsCheck(
      passed: json['passed'] as bool? ?? false,
      distanceMeters: asDouble(json['distance_meters']),
      allowedDistanceMeters: asDouble(json['allowed_distance_meters']),
      submittedLatitude: asDouble(json['submitted_latitude']),
      submittedLongitude: asDouble(json['submitted_longitude']),
      verifiedAt: DateTime.tryParse(json['verified_at'] as String? ?? ''),
    );
  }
}
