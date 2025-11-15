import 'dart:math';
import '../models/quiz_genie_models.dart';

class LocalQuizGenerator {
  static final _rnd = Random();

  static const _questionPatterns = [
    "What is {topic}?",
    "Which of the following is true about {topic}?",
    "Identify the correct statement regarding {topic}.",
    "Which option best describes {topic}?",
    "What is the main purpose of {topic}?",
    "Which example represents {topic}?",
  ];

  static const _optionPatterns = [
    "{topic} is a type of scientific concept.",
    "{topic} is used in daily life.",
    "{topic} cannot be applied in real-world situations.",
    "{topic} is related to advanced theories.",
    "{topic} has no practical use.",
    "{topic} is important for students.",
    "{topic} explains natural phenomena.",
  ];

  static GeneratedQuiz generateQuiz({
    required String topic,
    required String description,
    required int count,
  }) {
    final List<GeneratedQuestion> questions = [];

    for (int i = 0; i < count; i++) {
      final questionText = _questionPatterns[_rnd.nextInt(
            _questionPatterns.length,
          )]
          .replaceAll("{topic}", topic);

      final options =
          List<String>.from(
              _optionPatterns,
            ).map((e) => e.replaceAll("{topic}", topic)).toList()
            ..shuffle();

      final correctIndex = _rnd.nextInt(4);

      questions.add(
        GeneratedQuestion(
          id: "q${i + 1}",
          question: questionText,
          options: options.take(4).toList(),
          correctIndex: correctIndex,
        ),
      );
    }

    return GeneratedQuiz(
      title: "Quiz on $topic",
      description:
          description.isEmpty || description.toLowerCase() == 'no'
              ? "A practice quiz on $topic."
              : description,
      questions: questions,
    );
  }
}
