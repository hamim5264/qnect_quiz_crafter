import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local/local_quiz_generator.dart';
import '../models/quiz_genie_models.dart';

enum QuizGenieStatus { idle, generating, generated, saving, saved, error }

class QuizGenieState {
  final bool isFormOpen;
  final int step;
  final String topic;
  final String description;
  final int? questionCount;
  final QuizGenieGroup? group;
  final QuizGenieLevel? level;
  final GeneratedQuiz? quiz;
  final QuizGenieStatus status;
  final String? error;

  const QuizGenieState({
    required this.isFormOpen,
    required this.step,
    required this.topic,
    required this.description,
    required this.questionCount,
    required this.group,
    required this.level,
    required this.quiz,
    required this.status,
    required this.error,
  });

  factory QuizGenieState.initial() => const QuizGenieState(
    isFormOpen: false,
    step: 0,
    topic: '',
    description: '',
    questionCount: null,
    group: null,
    level: null,
    quiz: null,
    status: QuizGenieStatus.idle,
    error: null,
  );

  QuizGenieState copyWith({
    bool? isFormOpen,
    int? step,
    String? topic,
    String? description,
    int? questionCount,
    QuizGenieGroup? group,
    QuizGenieLevel? level,
    GeneratedQuiz? quiz,
    QuizGenieStatus? status,
    String? error,
  }) {
    return QuizGenieState(
      isFormOpen: isFormOpen ?? this.isFormOpen,
      step: step ?? this.step,
      topic: topic ?? this.topic,
      description: description ?? this.description,
      questionCount: questionCount ?? this.questionCount,
      group: group ?? this.group,
      level: level ?? this.level,
      quiz: quiz ?? this.quiz,
      status: status ?? this.status,
      error: error,
    );
  }
}

final quizGenieControllerProvider =
    NotifierProvider<QuizGenieController, QuizGenieState>(
      QuizGenieController.new,
    );

class QuizGenieController extends Notifier<QuizGenieState> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  QuizGenieState build() => QuizGenieState.initial();

  void openForm() => state = state.copyWith(isFormOpen: true, step: 0);

  void closeForm() => state = state.copyWith(isFormOpen: false);

  void setTopic(String v) => state = state.copyWith(topic: v);

  void setDescription(String v) => state = state.copyWith(description: v);

  void setCount(String v) =>
      state = state.copyWith(questionCount: int.tryParse(v));

  void setGroup(QuizGenieGroup v) => state = state.copyWith(group: v);

  void setLevel(QuizGenieLevel v) => state = state.copyWith(level: v);

  void nextStep() => state = state.copyWith(step: state.step + 1);

  void backStep() => state = state.copyWith(step: state.step - 1);

  bool get valid =>
      state.topic.isNotEmpty &&
      state.questionCount != null &&
      state.group != null &&
      state.level != null;

  Future<void> generate() async {
    state = state.copyWith(
      status: QuizGenieStatus.generating,
      isFormOpen: false,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    final quiz = LocalQuizGenerator.generateQuiz(
      topic: state.topic,
      description: state.description,
      count: state.questionCount ?? 10,
    );

    state = state.copyWith(quiz: quiz, status: QuizGenieStatus.generated);
  }

  Future<bool> saveToPractice({required String creatorRole}) async {
    final quiz = state.quiz;
    if (quiz == null ||
        state.group == null ||
        state.level == null ||
        state.questionCount == null) {
      state = state.copyWith(
        status: QuizGenieStatus.error,
        error: 'Missing quiz or form data.',
      );
      return false;
    }

    state = state.copyWith(status: QuizGenieStatus.saving);

    try {
      final uid = _auth.currentUser?.uid ?? 'unknown';

      final data = {
        'title': quiz.title,
        'description': quiz.description,
        'role': creatorRole,
        'creatorId': uid,
        'group': quizGenieGroupToString(state.group!),
        'level': quizGenieLevelToString(state.level!),
        'questionCount': quiz.questions.length,
        'createdAt': FieldValue.serverTimestamp(),
        'questions': quiz.questions.map((q) => q.toJson()).toList(),

        'published': false,

        'source': 'quiz_genie',
      };

      await _firestore.collection('practice_quizzes').add(data);

      state = QuizGenieState.initial().copyWith(status: QuizGenieStatus.saved);

      return true;
    } catch (e) {
      state = state.copyWith(
        status: QuizGenieStatus.error,
        error: e.toString(),
      );
      return false;
    }
  }
}
