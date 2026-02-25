class ChallengeQuestion {
  ChallengeQuestion({
    required this.questionId,
    required this.prompt,
    required this.type,
  });

  final String questionId;
  final String prompt;
  final String type;

  factory ChallengeQuestion.fromJson(Map<String, dynamic> json) {
    return ChallengeQuestion(
      questionId: json['question_id'] as String? ?? '',
      prompt: json['prompt'] as String? ?? '',
      type: json['type'] as String? ?? 'text',
    );
  }
}
