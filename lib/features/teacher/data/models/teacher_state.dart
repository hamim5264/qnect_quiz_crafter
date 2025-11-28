import 'teacher_model.dart';

class TeacherState {
  final bool loading;
  final bool buttonLoading;
  final TeacherModel? teacher;
  final String? error;

  const TeacherState({
    this.loading = false,
    this.buttonLoading = false,
    this.teacher,
    this.error,
  });

  TeacherState copyWith({
    bool? loading,
    bool? buttonLoading,
    TeacherModel? teacher,
    String? error,
  }) {
    return TeacherState(
      loading: loading ?? this.loading,
      buttonLoading: buttonLoading ?? this.buttonLoading,
      teacher: teacher ?? this.teacher,
      error: error,
    );
  }
}
