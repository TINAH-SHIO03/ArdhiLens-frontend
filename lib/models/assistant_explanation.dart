class AssistantExplanation {
  AssistantExplanation({
    required this.answer,
    required this.suggestedNextSteps,
  });

  final String answer;
  final List<String> suggestedNextSteps;

  factory AssistantExplanation.fromJson(Map<String, dynamic> json) {
    final assistant =
        (json['assistant'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    final steps = ((assistant['suggested_next_steps'] as List?) ?? const [])
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();

    return AssistantExplanation(
      answer: assistant['answer'] as String? ?? '',
      suggestedNextSteps: steps,
    );
  }
}

class AssistantChatMessage {
  AssistantChatMessage({
    required this.role,
    required this.text,
    this.steps = const [],
  });

  final String role; // user | assistant
  final String text;
  final List<String> steps;

  bool get isUser => role == 'user';
}
