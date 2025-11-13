import 'package:cloud_firestore/cloud_firestore.dart';

class QCVaultCourse {
  final String id;
  final String title;
  final String group;
  final String level;
  final int totalQuestions;

  QCVaultCourse({
    required this.id,
    required this.title,
    required this.group,
    required this.level,
    required this.totalQuestions,
  });

  factory QCVaultCourse.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return QCVaultCourse(
      id: doc.id,
      title: data['title'] ?? '',
      group: data['group'] ?? '',
      level: data['level'] ?? '',
      totalQuestions: (data['totalQuestions'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'group': group,
      'level': level,
      'totalQuestions': totalQuestions,
    };
  }
}

class QCVaultQuestion {
  final int index;
  final String question;
  final Map<String, String> options;
  final String correctOption;
  final String explanation;

  QCVaultQuestion({
    required this.index,
    required this.question,
    required this.options,
    required this.correctOption,
    required this.explanation,
  });

  factory QCVaultQuestion.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final rawOptions = Map<String, dynamic>.from(data['options'] ?? const {});

    final mapped = rawOptions.map(
      (key, value) => MapEntry(key, (value ?? '').toString()),
    );

    return QCVaultQuestion(
      index: (data['index'] ?? 0) as int,
      question: data['question'] ?? '',
      options: mapped,
      correctOption: data['correctOption'] ?? 'A',
      explanation: data['explanation'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    final normalizedOptions = options.map(
      (key, value) => MapEntry(key, value.trim().toLowerCase()),
    );

    return {
      'index': index,
      'question': question.trim(),
      'options': normalizedOptions,
      'correctOption': correctOption,
      'explanation': explanation.trim(),
    };
  }
}
