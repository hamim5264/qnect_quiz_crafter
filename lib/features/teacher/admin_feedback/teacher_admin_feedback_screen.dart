import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

import 'data/teacher_admin_feedback_provider.dart';
import 'widgets/rejected_course_card.dart';

class TeacherAdminFeedbackScreen extends ConsumerWidget {
  const TeacherAdminFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rejectedAsync = ref.watch(teacherRejectedCoursesProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Admin Feedback'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: rejectedAsync.when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error:
              (_, __) => const Center(
                child: Text(
                  'Failed to load feedback',
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white70,
                  ),
                ),
              ),
          data: (list) {
            if (list.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.task_alt, size: 70, color: Colors.white54),
                    SizedBox(height: 14),
                    Text(
                      'No rejected courses',
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final c = list[i];
                return RejectedCourseCard(
                  title: c['title'],
                  status: c['status'],
                  remark: c['remark'],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
