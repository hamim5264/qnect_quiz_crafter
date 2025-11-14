import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/add_surprise_quiz_model.dart';
import '../data/add_surprise_quiz_repository.dart';

class SurpriseQuizState {
  final List<SurpriseQuizQuestion>? imported;

  const SurpriseQuizState({this.imported});

  SurpriseQuizState copyWith({List<SurpriseQuizQuestion>? imported}) {
    return SurpriseQuizState(imported: imported ?? this.imported);
  }
}

class SurpriseQuizController extends Notifier<SurpriseQuizState> {
  @override
  SurpriseQuizState build() => const SurpriseQuizState();

  final _repo = SurpriseQuizRepository();

  Future<void> import20(String group, String level) async {
    final result = await _repo.import20RandomFromVault(
      group: group,
      level: level,
    );
    state = state.copyWith(imported: result);
  }

  Future<void> saveQuiz({
    required String title,
    required String description,
    required Duration duration,
    required int visibilityHours,
    required int points,
    required List<SurpriseQuizQuestion> questions,
    required String group,
    required String level,
    required String createdBy,
  }) async {
    await _repo.saveQuiz(
      title: title,
      description: description,
      duration: duration,
      visibilityHours: visibilityHours,
      points: points,
      group: group,
      level: level,
      createdBy: createdBy,
      questions: questions,
    );
  }

  Future<void> publishQuiz(String quizId) async {
    await _repo.publishQuiz(quizId);
  }

  Future<void> deleteQuiz(String quizId) async {
    await _repo.deleteQuiz(quizId);
  }
}

final surpriseQuizControllerProvider =
    NotifierProvider<SurpriseQuizController, SurpriseQuizState>(
      SurpriseQuizController.new,
    );

final surpriseQuizRepositoryProvider = Provider<SurpriseQuizRepository>(
  (ref) => SurpriseQuizRepository(),
);

final surpriseQuizListProvider =
    StreamProvider.family<List<SurpriseQuizListItem>, bool>((ref, published) {
      final repo = ref.read(surpriseQuizRepositoryProvider);
      return repo.watchQuizzes(published: published);
    });
