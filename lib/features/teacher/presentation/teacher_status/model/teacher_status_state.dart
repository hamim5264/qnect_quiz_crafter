import 'package:equatable/equatable.dart';

class TeacherStatusState extends Equatable {
  final bool loading;
  final String? name;
  final String? email;

  final String status;

  final int attemptCount;

  final String? rejectionTitle;
  final String? rejectionMessage;
  final List<String> feedback;

  const TeacherStatusState({
    this.loading = false,
    this.name,
    this.email,
    this.status = "pending",
    this.attemptCount = 1,
    this.rejectionTitle,
    this.rejectionMessage,
    this.feedback = const [],
  });

  TeacherStatusState copyWith({
    bool? loading,
    String? name,
    String? email,
    String? status,
    int? attemptCount,
    String? rejectionTitle,
    String? rejectionMessage,
    List<String>? feedback,
  }) {
    return TeacherStatusState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
      email: email ?? this.email,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      rejectionTitle: rejectionTitle ?? this.rejectionTitle,
      rejectionMessage: rejectionMessage ?? this.rejectionMessage,
      feedback: feedback ?? this.feedback,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    name,
    email,
    status,
    attemptCount,
    rejectionTitle,
    rejectionMessage,
    feedback,
  ];
}
