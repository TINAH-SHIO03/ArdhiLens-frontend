class ChallengeQuestion {
  ChallengeQuestion({
    required this.questionId,
    required this.prompt,
    required this.type,
    this.field,
    this.demoAnswer,
  });

  final String questionId;
  final String prompt;
  final String type;
  final String? field;
  final String? demoAnswer;

  factory ChallengeQuestion.fromJson(Map<String, dynamic> json) {
    return ChallengeQuestion(
      questionId: json['question_id'] as String? ?? '',
      prompt: json['prompt'] as String? ?? '',
      type: json['type'] as String? ?? 'text',
      field: json['field'] as String?,
      demoAnswer: json['demo_answer'] as String?,
    );
  }
}
