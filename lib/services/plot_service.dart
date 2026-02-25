import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../core/storage_service.dart';
import '../models/api_envelope.dart';
import '../models/plot_step_data.dart';

class PlotService {
  PlotService(this._apiClient, this._storage);

  final ApiClient _apiClient;
  final StorageService _storage;

  Future<PlotStepData> findPlot(String plotReference) async {
    final json = await _apiClient.post(
      '/land-verification/plot',
      data: {'plot_reference': plotReference},
    );

    final envelope = ApiEnvelope<PlotStepData>.fromJson(
      json,
      PlotStepData.fromJson,
    );

    if (!envelope.success || envelope.data == null) {
      throw ApiException(message: envelope.message, errors: envelope.errors);
    }

    await _storage.setVerificationToken(envelope.data!.verificationToken);
    return envelope.data!;
  }
}
