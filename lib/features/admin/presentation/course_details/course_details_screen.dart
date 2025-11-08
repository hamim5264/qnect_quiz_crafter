import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../common/widgets/common_confirm_dialog.dart';
import '../../../../common/widgets/action_success_dialog.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import 'widgets/header_course_card.dart';
import 'widgets/stats_and_status_grid.dart';
import 'widgets/quiz_item_card.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> courseData;

  const CourseDetailsScreen({super.key, required this.courseData});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  bool hasChanges = false;
  String courseStatus = 'Pending';
  String? rejectionReason;

  late List<Map<String, dynamic>> quizzes;

  @override
  void initState() {
    super.initState();

    quizzes = List<Map<String, dynamic>>.from(
      widget.courseData['quizzes'] ?? [],
    );
  }

  void _onStatusChanged(String value, {String? reason}) {
    setState(() {
      courseStatus = value;
      rejectionReason = reason;
      hasChanges = true;
    });
  }

  void _onEditQuiz(int index) {
    setState(() => hasChanges = true);
  }

  void _onDeleteQuiz(int index) {
    showDialog(
      context: context,
      builder:
          (_) => CommonConfirmDialog(
            title: "Delete Quiz",
            message: "Are you sure you want to delete this quiz?",
            icon: CupertinoIcons.trash,
            iconColor: Colors.red,
            confirmColor: Colors.red,
            onConfirm: () {
              setState(() {
                quizzes.removeAt(index);
                hasChanges = true;
              });
              showDialog(
                context: context,
                builder:
                    (_) => ActionSuccessDialog(
                      title: 'Success',
                      message: 'The quiz has been deleted successfully.',
                      onConfirm: () => Navigator.pop(context),
                    ),
              );
            },
          ),
    );
  }

  void _onDeleteCourse() {
    showDialog(
      context: context,
      builder:
          (_) => CommonConfirmDialog(
            title: "Delete Course",
            message: "Are you sure you want to delete this course?",
            icon: CupertinoIcons.trash,
            iconColor: Colors.red,
            confirmColor: Colors.red,
            onConfirm: () {
              showDialog(
                context: context,
                builder:
                    (_) => ActionSuccessDialog(
                      title: 'Success',
                      message: 'The course has been deleted successfully.',
                      onConfirm: () => Navigator.pop(context),
                    ),
              );
            },
          ),
    );
  }

  void _onUpdate() {
    showDialog(
      context: context,
      builder:
          (_) => ActionSuccessDialog(
            title: 'Success',
            message: 'Your changes have been updated successfully.',
            onConfirm: () {
              setState(() => hasChanges = false);
              Navigator.pop(context);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.courseData;
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CommonRoundedAppBar(title: course['title'] ?? 'Course Details'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            HeaderCourseCard(
              icon: course['icon'] ?? Icons.menu_book_rounded,
              title: course['title'] ?? 'Untitled Course',
              fullDescription:
                  course['description'] ?? 'No description available.',
              createdAtText: course['createdAt'] ?? 'Created at: --',
              price: course['price'] ?? 0,
              discountPercent: course['discount'] ?? 0,
            ),
            const SizedBox(height: 14),

            StatsAndStatusGrid(
              quizzes: course['quizCount'] ?? 0,
              enrolled: course['enrolled'] ?? 0,
              sold: course['sold'] ?? 0,
              price: course['price'] ?? 0,
              discountPercent: course['discount'] ?? 0,
              total: course['total'] ?? 0,
              durationText: course['duration'] ?? 'N/A',
              teacherName: course['teacherName'] ?? 'Unknown',
              teacherImage: course['teacherImage'],
              initialStatus: courseStatus,
              initialRejection: rejectionReason,
              onDeleteCourse: _onDeleteCourse,
              onEditCourse: () => setState(() => hasChanges = true),
              onStatusChanged: _onStatusChanged,
            ),
            const SizedBox(height: 16),

            ...List.generate(quizzes.length, (i) {
              final q = quizzes[i];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: i == quizzes.length - 1 ? 0 : 12,
                ),
                child: QuizItemCard(
                  icon: q['icon'] ?? Icons.help_outline,
                  title: q['title'] ?? 'Untitled Quiz',
                  description: q['desc'] ?? '',
                  points: q['points'] ?? 0,
                  timeLeft: q['timeLeft'] ?? '0 h 0 m',
                  onDetails: () {},
                  onEdit: () => _onEditQuiz(i),
                  onDelete: () => _onDeleteQuiz(i),
                ),
              );
            }),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: hasChanges ? _onUpdate : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      hasChanges
                          ? AppColors.primaryLight
                          : AppColors.white.withValues(alpha: 0.3),
                  disabledBackgroundColor: AppColors.white.withValues(
                    alpha: 0.3,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    color: hasChanges ? AppColors.white : Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
