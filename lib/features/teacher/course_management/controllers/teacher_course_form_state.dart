// lib/features/teacher/course_management/controllers/teacher_course_form_state.dart

import 'package:equatable/equatable.dart';
import '../models/teacher_course_model.dart';

class TeacherCourseFormState extends Equatable {
  final String? courseId;
  final String title;
  final String description;
  final double price;
  final String group;
  final String level;
  final String iconPath;
  final DateTime startDate;
  final DateTime endDate;
  final int discountPercent;
  final bool applyDiscount;
  final bool isSubmitting;
  final bool submitted;
  final CourseStatus status;
  final String? errorMessage;

  TeacherCourseFormState({
    this.courseId,
    this.title = '',
    this.description = '',
    this.price = 0,
    this.group = 'Science',
    this.level = 'HSC',
    this.iconPath = '',
    DateTime? startDate,
    DateTime? endDate,
    this.discountPercent = 0,
    this.applyDiscount = false,
    this.isSubmitting = false,
    this.submitted = false,
    this.status = CourseStatus.draft,
    this.errorMessage,
  })  : startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now().add(const Duration(days: 60));

  TeacherCourseFormState copyWith({
    String? courseId,
    String? title,
    String? description,
    double? price,
    String? group,
    String? level,
    String? iconPath,
    DateTime? startDate,
    DateTime? endDate,
    int? discountPercent,
    bool? applyDiscount,
    bool? isSubmitting,
    bool? submitted,
    CourseStatus? status,
    String? errorMessage,
  }) {
    return TeacherCourseFormState(
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      group: group ?? this.group,
      level: level ?? this.level,
      iconPath: iconPath ?? this.iconPath,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      discountPercent: discountPercent ?? this.discountPercent,
      applyDiscount: applyDiscount ?? this.applyDiscount,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitted: submitted ?? this.submitted,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    title,
    description,
    price,
    group,
    level,
    iconPath,
    startDate,
    endDate,
    discountPercent,
    applyDiscount,
    isSubmitting,
    submitted,
    status,
    errorMessage,
  ];
}
