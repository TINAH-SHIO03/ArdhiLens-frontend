import 'gps_check.dart';

class GpsStepData {
  GpsStepData({required this.gpsCheck, required this.nextStep});

  final GpsCheck gpsCheck;
  final String nextStep;

  factory GpsStepData.fromJson(Map<String, dynamic> json) {
    return GpsStepData(
      gpsCheck: GpsCheck.fromJson(
        (json['gps_check'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      nextStep: json['next_step'] as String? ?? '',
    );
  }
}
