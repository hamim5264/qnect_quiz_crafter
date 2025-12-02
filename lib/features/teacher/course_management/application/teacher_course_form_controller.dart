import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../course_management/data/models/course_model.dart';
import '../../../course_management/data/repositories/course_repository.dart';
import '../../../course_management/data/providers/course_providers.dart';
import 'teacher_course_form_state.dart';

final teacherCourseFormControllerProvider = NotifierProvider<
    TeacherCourseFormController, TeacherCourseFormState>(
  TeacherCourseFormController.new,
);

class TeacherCourseFormController extends Notifier<TeacherCourseFormState> {
  CourseRepository get _repo => ref.read(courseRepositoryProvider);

  @override
  TeacherCourseFormState build() {
    return TeacherCourseFormState();
  }

  void loadFromCourse(CourseModel course) {
    state = TeacherCourseFormState(
      courseId: course.id,
      title: course.title,
      description: course.description,
      price: course.price,
      group: course.group,
      level: course.level,
      remark: course.remark,
      iconPath: course.iconPath,
      startDate: course.startDate,
      endDate: course.endDate,
      discountPercent: course.discountPercent,
      applyDiscount: course.discountActive,
      status: course.status,
    );
  }

  void updateTitle(String v) =>
      state = state.copyWith(title: v, errorMessage: null);
  void updateDescription(String v) =>
      state = state.copyWith(description: v, errorMessage: null);
  void updatePrice(String v) =>
      state = state.copyWith(
        price: int.tryParse(v) ?? 0,
        errorMessage: null,
      );
  void updateGroup(String v) =>
      state = state.copyWith(group: v, errorMessage: null);
  void updateLevel(String v) =>
      state = state.copyWith(level: v, errorMessage: null);
  void updateRemark(String v) =>
      state = state.copyWith(remark: v, errorMessage: null);
  void updateIcon(String path) =>
      state = state.copyWith(iconPath: path, errorMessage: null);
  void updateStartDate(DateTime d) =>
      state = state.copyWith(startDate: d, errorMessage: null);
  void updateEndDate(DateTime d) =>
      state = state.copyWith(endDate: d, errorMessage: null);
  void updateDiscount(String v) {
    // v like "10%" or "Free"
    if (v == 'Free') {
      state = state.copyWith(
        discountPercent: 100,
        applyDiscount: true,
        errorMessage: null,
      );
    } else {
      final p = int.tryParse(v.replaceAll('%', '')) ?? 0;
      state = state.copyWith(
        discountPercent: p,
        errorMessage: null,
      );
    }
  }

  void updateApplyDiscount(bool v) =>
      state = state.copyWith(applyDiscount: v, errorMessage: null);

  Future<String?> submit(String teacherId) async {
    if (!state.canSubmit) return null;
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final course = CourseModel(
        id: state.courseId ?? '',
        teacherId: teacherId,
        title: state.title.trim(),
        description: state.description.trim(),
        price: state.price,
        group: state.group,
        level: state.level,
        remark: state.remark,
        iconPath: state.iconPath,
        startDate: state.startDate,
        endDate: state.endDate,
        discountPercent: state.applyDiscount ? state.discountPercent : 0,
        discountActive: state.applyDiscount,
        totalPrice: state.totalPrice,
        status: state.status,
        rejectionReason: null,
        quizzesCount: 0,
        enrolledCount: 0,
        soldCount: 0,
        totalDurationSeconds: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (state.isEdit) {
        await _repo.updateCourse(course.copyWith(id: state.courseId));
      } else {
        final id = await _repo.createCourse(course);
        state = state.copyWith(courseId: id);
      }
      state = state.copyWith(isSubmitting: false);
      return state.courseId;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }
}
