class SurpriseQuizQuestion {
  final String question;
  final Map<String, String> options;
  final String correct;
  final String explanation;

  SurpriseQuizQuestion({
    required this.question,
    required this.options,
    required this.correct,
    required this.explanation,
  });

  Map<String, dynamic> toMap() {
    return {
      "question": question.trim(),
      "options": options.map((k, v) => MapEntry(k, v.toLowerCase())),
      "correct": correct,
      "explanation": explanation.trim(),
    };
  }

  factory SurpriseQuizQuestion.fromMap(Map<String, dynamic> map) {
    return SurpriseQuizQuestion(
      question: map["question"] ?? "",
      options: Map<String, String>.from(map["options"] ?? {}),
      correct: map["correct"] ?? "A",
      explanation: map["explanation"] ?? "",
    );
  }
}
