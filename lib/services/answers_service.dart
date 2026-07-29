import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../models/api_envelope.dart';
import '../models/answer_input.dart';
import '../models/verification_result.dart';

class AnswersService {
  AnswersService(this._apiClient);

  final ApiClient _apiClient;

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

    return envelope.data!;
  }
}
