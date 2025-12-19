import 'package:flutter/material.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';
import '../../../models/teacher_course_model.dart';

class CourseDetailsTags extends StatelessWidget {
  final TeacherCourseModel course;

  const CourseDetailsTags({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _tag(course.level, Colors.orange),
        _tag(course.group, Colors.blue),
        _tag("${course.quizCount} Quizzes", Colors.green),
        _tag(course.status.name, _statusColor(course.status)),
        _tag("${course.price} BDT", Colors.amber),
      ],
    );
  }

  Color _statusColor(CourseStatus s) {
    return {
      CourseStatus.approved: Colors.green,
      CourseStatus.pending: Colors.orange,
      CourseStatus.rejected: Colors.red,
      CourseStatus.draft: Colors.grey,
    }[s]!;
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppTypography.family,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
