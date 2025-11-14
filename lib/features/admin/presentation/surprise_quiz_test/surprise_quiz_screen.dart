import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/surprise_quiz_test/add/add_surprise_quiz_screen.dart';

import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../common/widgets/action_success_dialog.dart';
import '../../../../../common/widgets/common_confirm_dialog.dart';
import '../../../../../common/widgets/app_skeleton.dart';
import '../../../../../ui/design_system/tokens/colors.dart';

import 'controller/add_surprise_quiz_controller.dart';
import 'data/add_surprise_quiz_repository.dart';
import 'widgets/surprise_quiz_card.dart';
import 'widgets/surprise_quiz_filter_bar.dart';

class SurpriseQuizScreen extends ConsumerStatefulWidget {
  const SurpriseQuizScreen({super.key});

  @override
  ConsumerState<SurpriseQuizScreen> createState() => _SurpriseQuizScreenState();
}

class _SurpriseQuizScreenState extends ConsumerState<SurpriseQuizScreen> {
  String selectedFilter = "Unpublished";

  void _showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    required IconData icon,
    required Color confirmColor,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => CommonConfirmDialog(
            title: title,
            message: message,
            icon: icon,
            iconColor: Colors.white,
            confirmColor: confirmColor,
            onConfirm: onConfirm,
          ),
    );
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (_) => ActionSuccessDialog(
            title: title,
            message: message,
            onConfirm: () => Navigator.pop(context),
          ),
    );
  }

  String _buildTimeRemaining(SurpriseQuizListItem quiz) {
    if (!quiz.published) {
      return "Not started";
    }

    final publishedAt = quiz.publishedAt?.toDate();
    if (publishedAt == null) {
      return "Not started";
    }

    final endTime = publishedAt.add(Duration(hours: quiz.visibilityHours));
    final now = DateTime.now();

    if (now.isAfter(endTime)) {
      return "Expired";
    }

    final diff = endTime.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    if (hours > 0) {
      return "${hours}h ${minutes}m left";
    } else {
      return "${minutes}m left";
    }
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.88,
      ),
      itemBuilder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              SizedBox(height: 6),
              AppSkeleton(
                width: 40,
                height: 40,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              SizedBox(height: 8),
              AppSkeleton(width: double.infinity, height: 14),
              SizedBox(height: 6),
              AppSkeleton(width: double.infinity, height: 10),
              SizedBox(height: 6),
              AppSkeleton(width: double.infinity, height: 10),
              Spacer(),
              AppSkeleton(width: double.infinity, height: 32),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final showPublished = selectedFilter == "Published";

    final quizzesAsync = ref.watch(surpriseQuizListProvider(showPublished));

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Surprise Quizzes'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SurpriseQuizFilterBar(
                selected: selectedFilter,
                onSelect: (value) {
                  setState(() => selectedFilter = value);
                },
              ),

              const SizedBox(height: 12),

              Expanded(
                child: quizzesAsync.when(
                  data: (quizzes) {
                    if (quizzes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                CupertinoIcons.cube_box,
                                color: Colors.white70,
                                size: 42,
                              ),
                            ),

                            const SizedBox(height: 16),

                            const Text(
                              "No surprise quiz found",
                              style: TextStyle(
                                fontFamily: "Barlow",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              "Create a new quiz to get started.",
                              style: TextStyle(
                                fontFamily: "Barlow",
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      itemCount: quizzes.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.70,
                          ),
                      itemBuilder: (context, index) {
                        final quiz = quizzes[index];

                        final durationMinutes =
                            (quiz.durationSeconds / 60).round();
                        final quizTimeText = "$durationMinutes min";

                        final timeRemaining = _buildTimeRemaining(quiz);

                        return SurpriseQuizCard(
                          title: quiz.title,
                          subtitle: quiz.description,
                          icon: "SQ",
                          group: quiz.group,
                          level: quiz.level,
                          quizTime: quizTimeText,
                          timeRemainingText: timeRemaining,
                          isPublished: quiz.published,

                          onPublish: () {
                            if (quiz.published) return;

                            _showConfirmDialog(
                              title: "Publish Quiz",
                              message:
                                  "Are you sure you want to publish this surprise quiz for ${quiz.group} • ${quiz.level}?",
                              icon: CupertinoIcons.paperplane,
                              confirmColor: AppColors.chip2,

                              onConfirm: () async {
                                Navigator.pop(context);

                                await ref
                                    .read(
                                      surpriseQuizControllerProvider.notifier,
                                    )
                                    .publishQuiz(quiz.id);

                                if (!mounted) return;

                                _showSuccessDialog(
                                  "Published Successfully",
                                  "This surprise quiz is now live for ${quiz.group} • ${quiz.level} students.",
                                );
                              },
                            );
                          },

                          onDelete: () {
                            _showConfirmDialog(
                              title: "Delete Quiz",
                              message:
                                  "Are you sure you want to delete this surprise quiz?",
                              icon: CupertinoIcons.trash,
                              confirmColor: Colors.redAccent,

                              onConfirm: () async {
                                Navigator.pop(context);

                                await ref
                                    .read(
                                      surpriseQuizControllerProvider.notifier,
                                    )
                                    .deleteQuiz(quiz.id);

                                if (!mounted) return;

                                _showSuccessDialog(
                                  "Deleted Successfully",
                                  "This quiz has been removed.",
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                  loading: () => _buildLoadingGrid(),
                  error:
                      (e, st) => Center(
                        child: Text(
                          'Error: $e',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontFamily: 'Barlow',
                          ),
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSurpriseQuizScreen(),
            ),
          );
        },
        child: const Icon(
          CupertinoIcons.add_circled_solid,
          color: AppColors.primaryLight,
          size: 28,
        ),
      ),
    );
  }
}
