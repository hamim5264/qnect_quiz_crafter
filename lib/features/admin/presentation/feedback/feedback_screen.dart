import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

import 'data/feedback_providers.dart';
import 'widgets/feedback_search_bar.dart';
import 'widgets/feedback_count_box.dart';
import 'widgets/feedback_card.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final roleAsync = ref.watch(feedbackRoleProvider);
    final feedbackAsync = ref.watch(allFeedbackProvider);
    final countAsync = ref.watch(allFeedbackCountProvider);

    final role = roleAsync.maybeWhen(data: (r) => r, orElse: () => null);

    final isAdmin = role == 'admin';

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Course Feedback'),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryLight,
        child: const Icon(Icons.add),
        onPressed: () {
          if (role == 'student') {
            context.pushNamed('addFeedback');
          } else {
            _showRoleRestrictedPopup(context, role);
          }
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FeedbackSearchBar(onChanged: (v) => setState(() => query = v)),
            const SizedBox(height: 14),

            countAsync.when(
              data: (c) => FeedbackCountBox(total: c),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: feedbackAsync.when(
                loading:
                    () => const Center(child: CupertinoActivityIndicator()),
                error:
                    (e, _) => Center(
                      child: Text(
                        'Failed to load feedback',
                        style: TextStyle(
                          color: Colors.white70,
                          fontFamily: AppTypography.family,
                        ),
                      ),
                    ),
                data: (list) => _buildList(list, isAdmin),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoleRestrictedPopup(BuildContext context, String? role) {
    final roleText = role == 'teacher' ? 'Teacher' : 'Admin';

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: AppColors.primaryDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Action Not Allowed',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              '$roleText accounts cannot submit feedback.\nOnly students are allowed.',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> list, bool isAdmin) {
    final filtered =
        list.where((f) {
          final text =
              '${f['courseName']} ${f['teacherName']} ${f['userName']}'
                  .toLowerCase();
          return text.contains(query.toLowerCase());
        }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.rate_review_outlined, size: 80, color: Colors.white54),
            SizedBox(height: 14),
            Text(
              'No feedback found',
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

    final avg = _calculateAverage(filtered);

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final f = filtered[i];

        return FeedbackCard(
          name: f['userName'],
          stars: f['stars'],
          teacher: f['teacherName'],
          course: f['courseName'],
          comment: f['comment'],
          average: avg,
          profileImage: f['profileImage'],
          onDelete: isAdmin ? () => _deleteFeedback(f['id']) : null,
        );
      },
    );
  }

  double _calculateAverage(List<Map<String, dynamic>> list) {
    final total = list.fold<int>(0, (s, f) => s + (f['stars'] as int));
    return double.parse((total / list.length).toStringAsFixed(1));
  }

  Future<void> _deleteFeedback(String feedbackId) async {
    await FirebaseFirestore.instance
        .collection('feedback')
        .doc(feedbackId)
        .delete();
  }
}
