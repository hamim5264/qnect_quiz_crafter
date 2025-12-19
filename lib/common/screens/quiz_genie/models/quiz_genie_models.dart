import 'dart:convert';

enum QuizGenieGroup { science, arts, commerce }

enum QuizGenieLevel { ssc, hsc }

String quizGenieGroupToString(QuizGenieGroup g) => g.toString().split('.').last;

String quizGenieLevelToString(QuizGenieLevel l) => l.toString().split('.').last;

class QuizGenieRequest {
  final String topic;
  final String description;
  final int questionCount;
  final QuizGenieGroup group;
  final QuizGenieLevel level;

  const QuizGenieRequest({
    required this.topic,
    required this.description,
    required this.questionCount,
    required this.group,
    required this.level,
  });
}

class GeneratedQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;

  const GeneratedQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory GeneratedQuestion.fromJson(Map<String, dynamic> json) {
    return GeneratedQuestion(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctIndex: json['correctIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctIndex': correctIndex,
    };
  }
}

class GeneratedQuiz {
  final String title;
  final String description;
  final List<GeneratedQuestion> questions;

  const GeneratedQuiz({
    required this.title,
    required this.description,
    required this.questions,
  });

  static GeneratedQuiz fromJsonString(String text) {
    final data = jsonDecode(text);
    return GeneratedQuiz(
      title: data['title'],
      description: data['description'],
      questions:
          (data['questions'] as List)
              .map((e) => GeneratedQuestion.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'questionCount': questions.length,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}
