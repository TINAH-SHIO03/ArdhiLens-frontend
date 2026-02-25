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
  }) async {
    final json = await _apiClient.post(
      '/land-verification/gps',
      data: {
        'verification_token': verificationToken,
        'latitude': latitude,
        'longitude': longitude,
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
