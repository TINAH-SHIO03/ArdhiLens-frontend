class AssistantExplanation {
  AssistantExplanation({
    required this.related,
    required this.answer,
    required this.recommendedAction,
    required this.suggestedNextSteps,
  });

  final bool related;
  final String answer;
  final String recommendedAction;
  final List<String> suggestedNextSteps;

  factory AssistantExplanation.fromJson(Map<String, dynamic> json) {
    final assistant =
        (json['assistant'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    final steps = ((assistant['suggested_next_steps'] as List?) ?? const [])
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
    final recommendedAction = (assistant['recommended_action'] as String? ?? '')
        .trim();

    if (steps.isEmpty && recommendedAction.isNotEmpty) {
      steps.add(recommendedAction);
    }

    return AssistantExplanation(
      related: assistant['related'] as bool? ?? true,
      answer: assistant['answer'] as String? ?? '',
      recommendedAction: recommendedAction,
      suggestedNextSteps: steps,
    );
  }
}

class AssistantChatMessage {
  AssistantChatMessage({
    required this.role,
    required this.text,
    this.related = true,
    this.recommendedAction = '',
    this.steps = const [],
  });

  final String role; // user | assistant
  final String text;
  final bool related;
  final String recommendedAction;
  final List<String> steps;

  bool get isUser => role == 'user';
}
