import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/action_success_dialog.dart';
import '../../../../../../common/widgets/common_confirm_dialog.dart';
import '../../../../../../common/widgets/success_failure_dialog.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class QuizListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final IconData icon;

  final int attempts;
  final int totalStudents;

  final Future<void> Function() onDelete;

  const QuizListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.icon,
    required this.attempts,
    required this.totalStudents,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Icon(icon, size: 26, color: Colors.white)),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => CommonConfirmDialog(
                                title: "Delete Quiz?",
                                message:
                                    "Are you sure you want to delete this quiz? This action cannot be undone.",
                                icon: CupertinoIcons.trash,
                                iconColor: Colors.redAccent,
                                confirmColor: Colors.redAccent,
                                onConfirm: () async {
                                  try {
                                    await onDelete();

                                    showDialog(
                                      context: context,
                                      builder:
                                          (_) => ActionSuccessDialog(
                                            title: "Deleted",
                                            message:
                                                "Quiz has been deleted successfully.",
                                            onConfirm:
                                                () => Navigator.pop(context),
                                          ),
                                    );
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (_) => SuccessFailureDialog(
                                            icon: Icons.error_outline_rounded,
                                            title: "Delete Failed!",
                                            subtitle:
                                                "Something went wrong:\n${e.toString()}",
                                            buttonText: "Close",
                                            onPressed:
                                                () => Navigator.pop(context),
                                          ),
                                    );
                                  }
                                },
                              ),
                        );
                      },
                      icon: const Icon(
                        CupertinoIcons.trash,
                        color: Colors.redAccent,
                        size: 22,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (progress / 100).clamp(0.0, 1.0),
                    backgroundColor: Colors.white.withValues(alpha: 0.4),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.secondaryDark,
                    ),
                    minHeight: 8,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "Time Left: ${progress.toStringAsFixed(0)}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: AppTypography.family,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.chip3,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Attempts: $attempts / $totalStudents",
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 13,
                      color: AppColors.chip1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
