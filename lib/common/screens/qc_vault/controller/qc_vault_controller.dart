import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/qc_vault_models.dart';
import '../data/qc_vault_repository.dart';

final qcVaultRepositoryProvider = Provider<QCVaultRepository>((ref) {
  return QCVaultRepository(FirebaseFirestore.instance);
});

class QCVaultFilter extends Equatable {
  final String group;
  final String level;

  const QCVaultFilter({required this.group, required this.level});

  @override
  List<Object?> get props => [group, level];
}

final qcVaultCoursesProvider =
    StreamProvider.family<List<QCVaultCourse>, QCVaultFilter>((ref, filter) {
      final repo = ref.read(qcVaultRepositoryProvider);
      return repo.watchCourses(group: filter.group, level: filter.level);
    });

final qcVaultQuestionsProvider =
    StreamProvider.family<List<QCVaultQuestion>, String>((ref, courseId) {
      final repo = ref.read(qcVaultRepositoryProvider);
      return repo.watchQuestions(courseId);
    });

class QCVaultAddState extends Equatable {
  final bool isSaving;
  final String? errorMessage;
  final bool success;

  const QCVaultAddState({
    required this.isSaving,
    required this.errorMessage,
    required this.success,
  });

  factory QCVaultAddState.initial() => const QCVaultAddState(
    isSaving: false,
    errorMessage: null,
    success: false,
  );

  QCVaultAddState copyWith({
    bool? isSaving,
    String? errorMessage,
    bool? success,
  }) {
    return QCVaultAddState(
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [isSaving, errorMessage, success];
}

class QCVaultAddController extends Notifier<QCVaultAddState> {
  QCVaultRepository get _repo => ref.read(qcVaultRepositoryProvider);

  @override
  QCVaultAddState build() => QCVaultAddState.initial();

  Future<void> addQuestion({
    required String courseId,
    required String question,
    required Map<String, String> options,
    required String correctOption,
    required String explanation,
  }) async {
    state = state.copyWith(isSaving: true, errorMessage: null, success: false);

    try {
      await _repo.addQuestion(
        courseId: courseId,
        question: question,
        options: options,
        correctOption: correctOption,
        explanation: explanation,
      );

      state = state.copyWith(isSaving: false, success: true);
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.toString());
    }
  }
}

final qcVaultAddControllerProvider =
    NotifierProvider<QCVaultAddController, QCVaultAddState>(
      QCVaultAddController.new,
    );
