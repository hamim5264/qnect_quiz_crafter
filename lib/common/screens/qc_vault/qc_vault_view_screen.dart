import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../ui/design_system/tokens/colors.dart';
import '../../../ui/design_system/tokens/typography.dart';
import '../../../common/widgets/common_rounded_app_bar.dart';
import 'controller/qc_vault_controller.dart';
import '../../../common/widgets/skeleton/qc_vault_question_skeleton.dart';

class QCVaultViewScreen extends ConsumerWidget {
  final String courseId;
  final String courseTitle;

  const QCVaultViewScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(qcVaultQuestionsProvider(courseId));

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CommonRoundedAppBar(
        title: courseTitle,
        titleSize: 18,
        ellipsis: false,
        maxLines: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: questionsAsync.when(
            data: (questions) {
              if (questions.isEmpty) {
                return const Center(
                  child: Text(
                    'No questions yet',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppTypography.family,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.question,
                          style: const TextStyle(
                            fontFamily: AppTypography.family,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),

                        ...['A', 'B', 'C', 'D'].map((label) {
                          final text = q.options[label] ?? '';
                          final isCorrect = label == q.correctOption;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isCorrect
                                      ? AppColors.white
                                      : AppColors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    isCorrect
                                        ? AppColors.chip2
                                        : Colors.white24,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color:
                                        isCorrect
                                            ? AppColors.chip2
                                            : Colors.white12,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      fontFamily: AppTypography.family,
                                      color:
                                          isCorrect
                                              ? AppColors.white
                                              : Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      fontFamily: AppTypography.family,
                                      color:
                                          isCorrect
                                              ? AppColors.textPrimary
                                              : Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              );
            },

            error:
                (e, st) => Center(
                  child: Text(
                    'Error: $e',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),

            loading:
                () => ListView.builder(
                  itemCount: 6,
                  itemBuilder: (_, __) => const QCVaultQuestionSkeleton(),
                ),
          ),
        ),
      ),
    );
  }
}
