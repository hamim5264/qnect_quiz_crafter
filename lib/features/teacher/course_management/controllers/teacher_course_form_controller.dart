// lib/features/teacher/course_management/application/teacher_course_form_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/teacher_course_model.dart';
import '../repositories/teacher_course_repository.dart';
import 'teacher_course_form_state.dart';

class TeacherCourseFormController
    extends StateNotifier<TeacherCourseFormState> {
  final TeacherCourseRepository repo;
  final String teacherId;

  TeacherCourseFormController(this.repo, this.teacherId)
      : super(TeacherCourseFormState());

  void updateTitle(String v) => state = state.copyWith(title: v);
  void updateDescription(String v) => state = state.copyWith(description: v);
  void updatePrice(String v) =>
      state = state.copyWith(price: double.tryParse(v) ?? 0);
  void updateGroup(String v) => state = state.copyWith(group: v);
  void updateLevel(String v) => state = state.copyWith(level: v);
  void updateIcon(String v) => state = state.copyWith(iconPath: v);
  void updateStartDate(DateTime d) => state = state.copyWith(startDate: d);
  void updateEndDate(DateTime d) => state = state.copyWith(endDate: d);
  void updateDiscount(int v) => state = state.copyWith(discountPercent: v);
  void updateApplyDiscount(bool v) =>
      state = state.copyWith(applyDiscount: v);

  Future<void> submit() async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final now = DateTime.now();

      final model = TeacherCourseModel(
        id: '',
        teacherId: teacherId,
        title: state.title,
        description: state.description,
        price: state.price,
        group: state.group,
        level: state.level,
        remark: null, // remark optional, we are not using it now
        iconPath: state.iconPath,
        startDate: state.startDate,
        endDate: state.endDate,
        discountPercent: state.discountPercent,
        applyDiscount: state.applyDiscount,
        status: CourseStatus.draft,
        quizCount: 0,
        createdAt: now,
        updatedAt: now,
      );

      final courseId = await repo.createCourse(model);

      state = state.copyWith(
        isSubmitting: false,
        submitted: true,
        courseId: courseId,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
    }
  }
}
