import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../models/api_envelope.dart';
import '../models/gps_step_data.dart';

class GpsService {
  GpsService(this._apiClient);

  final ApiClient _apiClient;

  Future<GpsStepData> verifyGps({
    required String verificationToken,
    required double latitude,
    required double longitude,
    double? accuracyMeters,
    double? altitude,
    double? speedMps,
    String mode = 'remote',
  }) async {
    final json = await _apiClient.post(
      '/land-verification/gps',
      data: {
        'verification_token': verificationToken,
        'latitude': latitude,
        'longitude': longitude,
        'mode': mode,
        if (accuracyMeters != null) 'accuracy_meters': accuracyMeters,
        if (altitude != null) 'altitude': altitude,
        if (speedMps != null) 'speed_mps': speedMps,
      },
    );

    final envelope = ApiEnvelope<GpsStepData>.fromJson(
      json,
      GpsStepData.fromJson,
    );

    if (!envelope.success || envelope.data == null) {
      throw ApiException(message: envelope.message, errors: envelope.errors);
    }

    return envelope.data!;
  }
}
