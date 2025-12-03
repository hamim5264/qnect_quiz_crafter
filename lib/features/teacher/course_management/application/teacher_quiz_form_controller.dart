import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../course_management/data/models/quiz_model.dart';
import '../../../course_management/data/repositories/quiz_repository.dart';
import '../../../course_management/data/repositories/course_repository.dart';
import '../../../course_management/data/providers/course_providers.dart';
import 'teacher_quiz_form_state.dart';

final teacherQuizFormControllerProvider =
    NotifierProvider<TeacherQuizFormController, TeacherQuizFormState>(
      TeacherQuizFormController.new,
    );

class TeacherQuizFormController extends Notifier<TeacherQuizFormState> {
  QuizRepository get _quizRepo => ref.read(quizRepositoryProvider);

  CourseRepository get _courseRepo => ref.read(courseRepositoryProvider);

  @override
  TeacherQuizFormState build() => TeacherQuizFormState();

  void loadFromQuiz(QuizModel quiz) {
    state = TeacherQuizFormState(
      quizId: quiz.id,
      title: quiz.title,
      description: quiz.description,
      points: quiz.points,
      duration: Duration(seconds: quiz.durationSeconds),
      iconKey: quiz.iconKey,
      startDate: quiz.startDate,
      endDate: quiz.endDate,
    );
  }

  void updateTitle(String v) =>
      state = state.copyWith(title: v, errorMessage: null);

  void updateDescription(String v) =>
      state = state.copyWith(description: v, errorMessage: null);

  void updateDuration(Duration d) =>
      state = state.copyWith(duration: d, errorMessage: null);

  void updateIcon(String key) =>
      state = state.copyWith(iconKey: key, errorMessage: null);

  void updateStartDate(DateTime d) =>
      state = state.copyWith(startDate: d, errorMessage: null);

  void updateEndDate(DateTime d) =>
      state = state.copyWith(endDate: d, errorMessage: null);

  Future<String?> submit({
    required String teacherId,
    required String courseId,
    required DateTime courseStart,
    required DateTime courseEnd,
  }) async {
    if (!state.canSubmit) return null;

    if (state.startDate.isBefore(courseStart) ||
        state.endDate.isAfter(courseEnd)) {
      state = state.copyWith(
        errorMessage: 'Quiz dates must be between course start and end date.',
      );
      return null;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final quiz = QuizModel(
        id: state.quizId ?? '',
        courseId: courseId,
        teacherId: teacherId,
        title: state.title.trim(),
        description: state.description.trim(),
        points: state.points,
        durationSeconds: state.duration.inSeconds,
        iconKey: state.iconKey,
        startDate: state.startDate,
        endDate: state.endDate,
        totalQuestions: 0,
        totalLikes: 0,
        totalAttempts: 0,
        isPractice: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (state.isEdit) {
        await _quizRepo.updateQuiz(quiz.copyWith(id: state.quizId));
      } else {
        final quizId = await _quizRepo.createQuiz(quiz);
        await _courseRepo.incrementQuizStats(
          courseId: courseId,
          quizDurationSecondsDelta: quiz.durationSeconds,
        );
        state = state.copyWith(quizId: quizId);
      }

      state = state.copyWith(isSubmitting: false);
      return state.quizId;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return null;
    }
  }
}
