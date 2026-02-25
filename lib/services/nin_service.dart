import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../core/storage_service.dart';
import '../models/api_envelope.dart';
import '../models/nin_question_step_data.dart';

class NinService {
  NinService(this._apiClient, this._storage);

  final ApiClient _apiClient;
  final StorageService _storage;

  Future<NinQuestionStepData> generateQuestions({
    required String verificationToken,
    required String nin,
  }) async {
    final json = await _apiClient.post(
      '/land-verification/nin/questions',
      data: {'verification_token': verificationToken, 'nin': nin},
    );

    final envelope = ApiEnvelope<NinQuestionStepData>.fromJson(
      json,
      NinQuestionStepData.fromJson,
    );

    if (!envelope.success || envelope.data == null) {
      throw ApiException(message: envelope.message, errors: envelope.errors);
    }

    await _storage.setChallengeId(envelope.data!.challengeId);
    await _storage.setChallengeExpiresAt(envelope.data!.expiresAt);

    return envelope.data!;
  }
}
