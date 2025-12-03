import 'package:equatable/equatable.dart';

class TeacherQuizFormState extends Equatable {
  final String? quizId;
  final String title;
  final String description;
  final int points;
  final Duration duration;
  final String iconKey;
  final DateTime startDate;
  final DateTime endDate;
  final bool isSubmitting;
  final String? errorMessage;

  TeacherQuizFormState({
    this.quizId,
    this.title = '',
    this.description = '',
    this.points = 0,
    this.duration = const Duration(minutes: 10),
    this.iconKey = '',
    DateTime? startDate,
    DateTime? endDate,
    this.isSubmitting = false,
    this.errorMessage,
  }) : startDate = startDate ?? DateTime.now(),
       endDate = endDate ?? DateTime.now().add(const Duration(days: 1));

  bool get isEdit => quizId != null;

  bool get canSubmit {
    if (title.trim().isEmpty) return false;
    if (duration.inSeconds <= 0) return false;
    if (startDate.isAfter(endDate)) return false;
    return !isSubmitting;
  }

  TeacherQuizFormState copyWith({
    String? quizId,
    String? title,
    String? description,
    int? points,
    Duration? duration,
    String? iconKey,
    DateTime? startDate,
    DateTime? endDate,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return TeacherQuizFormState(
      quizId: quizId ?? this.quizId,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      duration: duration ?? this.duration,
      iconKey: iconKey ?? this.iconKey,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    quizId,
    title,
    description,
    points,
    duration,
    iconKey,
    startDate,
    endDate,
    isSubmitting,
    errorMessage,
  ];
}
