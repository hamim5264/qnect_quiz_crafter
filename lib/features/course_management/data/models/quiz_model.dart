import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final String id;
  final String courseId;
  final String teacherId;
  final String title;
  final String description;
  final int points; // reward
  final int durationSeconds;
  final String iconKey; // Lucide icon key or some mapping
  final DateTime startDate;
  final DateTime endDate;
  final int totalQuestions;
  final int totalLikes;
  final int totalAttempts;
  final bool isPractice;

  final DateTime createdAt;
  final DateTime updatedAt;

  const QuizModel({
    required this.id,
    required this.courseId,
    required this.teacherId,
    required this.title,
    required this.description,
    required this.points,
    required this.durationSeconds,
    required this.iconKey,
    required this.startDate,
    required this.endDate,
    required this.totalQuestions,
    required this.totalLikes,
    required this.totalAttempts,
    required this.isPractice,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'teacherId': teacherId,
      'title': title,
      'description': description,
      'points': points,
      'durationSeconds': durationSeconds,
      'iconKey': iconKey,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'totalQuestions': totalQuestions,
      'totalLikes': totalLikes,
      'totalAttempts': totalAttempts,
      'isPractice': isPractice,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory QuizModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuizModel(
      id: doc.id,
      courseId: data['courseId'] as String,
      teacherId: data['teacherId'] as String,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      points: data['points'] as int? ?? 0,
      durationSeconds: data['durationSeconds'] as int? ?? 0,
      iconKey: data['iconKey'] as String? ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      totalQuestions: data['totalQuestions'] as int? ?? 0,
      totalLikes: data['totalLikes'] as int? ?? 0,
      totalAttempts: data['totalAttempts'] as int? ?? 0,
      isPractice: data['isPractice'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  QuizModel copyWith({
    String? id,
    String? courseId,
    String? teacherId,
    String? title,
    String? description,
    int? points,
    int? durationSeconds,
    String? iconKey,
    DateTime? startDate,
    DateTime? endDate,
    int? totalQuestions,
    int? totalLikes,
    int? totalAttempts,
    bool? isPractice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuizModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      teacherId: teacherId ?? this.teacherId,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      iconKey: iconKey ?? this.iconKey,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      totalLikes: totalLikes ?? this.totalLikes,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      isPractice: isPractice ?? this.isPractice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
