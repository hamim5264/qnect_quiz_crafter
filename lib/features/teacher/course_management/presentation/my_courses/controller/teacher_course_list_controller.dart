import '../../../data/teacher_course_service.dart';

class TeacherCourseListController {
  final TeacherCourseService service;

  TeacherCourseListController(this.service);

  Future<void> deleteCourse(String courseId) async {
    await service.deleteCourse(courseId);
  }
}
