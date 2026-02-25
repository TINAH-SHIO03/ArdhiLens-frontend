class AnswerInput {
  AnswerInput({required this.questionId, required this.answer});

  final String questionId;
  final String answer;

  Map<String, dynamic> toJson() {
    return {'question_id': questionId, 'answer': answer};
  }
}
