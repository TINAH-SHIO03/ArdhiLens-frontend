import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../core/storage_service.dart';
import '../models/api_envelope.dart';
import '../models/answer_input.dart';
import '../models/verification_result.dart';

class AnswersService {
  AnswersService(this._apiClient, this._storage);

  final ApiClient _apiClient;
  final StorageService _storage;

  Future<VerificationResult> verifyAnswers({
    required String verificationToken,
    required String challengeId,
    required List<AnswerInput> answers,
  }) async {
    final json = await _apiClient.post(
      '/land-verification/nin/answers',
      data: {
        'verification_token': verificationToken,
        'challenge_id': challengeId,
        'answers': answers.map((item) => item.toJson()).toList(),
      },
    );

    final envelope = ApiEnvelope<VerificationResult>.fromJson(
      json,
      VerificationResult.fromJson,
    );

    if (!envelope.success || envelope.data == null) {
      throw ApiException(message: envelope.message, errors: envelope.errors);
    }

    await _storage.clearVerificationSession();
    return envelope.data!;
  }
}
