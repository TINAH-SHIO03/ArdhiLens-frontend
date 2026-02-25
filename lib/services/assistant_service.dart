import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../models/api_envelope.dart';
import '../models/assistant_explanation.dart';

class AssistantService {
  AssistantService(this._apiClient);

  final ApiClient _apiClient;

  Future<AssistantExplanation> explainAssessment({
    required int verificationLogId,
    required String question,
    List<Map<String, String>> conversationHistory = const [],
  }) async {
    final payload = <String, dynamic>{
      'verification_log_id': verificationLogId,
      'question': question,
    };

    if (conversationHistory.isNotEmpty) {
      payload['conversation_history'] = conversationHistory;
    }

    final json = await _apiClient.post(
      '/land-verification/assistant/explain',
      data: payload,
    );

    final envelope = ApiEnvelope<AssistantExplanation>.fromJson(
      json,
      AssistantExplanation.fromJson,
    );

    if (!envelope.success || envelope.data == null) {
      throw ApiException(message: envelope.message, errors: envelope.errors);
    }

    return envelope.data!;
  }
}
