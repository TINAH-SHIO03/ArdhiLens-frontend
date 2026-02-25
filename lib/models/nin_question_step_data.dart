import 'challenge_question.dart';

class NinQuestionStepData {
  NinQuestionStepData({
    required this.challengeId,
    required this.expiresAt,
    required this.questions,
    required this.nextStep,
  });

  final String challengeId;
  final DateTime expiresAt;
  final List<ChallengeQuestion> questions;
  final String nextStep;

  factory NinQuestionStepData.fromJson(Map<String, dynamic> json) {
    final rawQuestions = (json['questions'] as List?) ?? const [];

    return NinQuestionStepData(
      challengeId: json['challenge_id'] as String? ?? '',
      expiresAt:
          DateTime.tryParse(json['expires_at'] as String? ?? '') ??
          DateTime.now().add(const Duration(minutes: 5)),
      questions: rawQuestions
          .whereType<Map>()
          .map(
            (item) => ChallengeQuestion.fromJson(item.cast<String, dynamic>()),
          )
          .toList(),
      nextStep: json['next_step'] as String? ?? '',
    );
  }
}
