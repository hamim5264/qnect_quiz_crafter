import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizItemCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final int points;
  final VoidCallback onDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String timeLeft;

  const QuizItemCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.points,
    required this.onDetails,
    required this.onEdit,
    required this.onDelete,
    required this.timeLeft,
  });

  @override
  State<QuizItemCard> createState() => _QuizItemCardState();
}

class _QuizItemCardState extends State<QuizItemCard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDetails,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: AppTypography.family,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: AppTypography.family,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 6),

                          Row(
                            children: [
                              _chip('${widget.points} Points'),
                              const SizedBox(width: 6),
                              _filledChip('Details', widget.onDetails),
                              const SizedBox(width: 8),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed:
                                        () => context.pushNamed('editQuiz'),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    iconSize: 18,
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    visualDensity: const VisualDensity(
                                      horizontal: -4,
                                      vertical: -4,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: widget.onDelete,
                                    icon: const Icon(
                                      CupertinoIcons.delete,
                                      color: Colors.red,
                                    ),
                                    iconSize: 18,
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    visualDensity: const VisualDensity(
                                      horizontal: -4,
                                      vertical: -4,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                right: 6,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      context.pushNamed('adminQuizQuestionsInfo');
                    },
                    icon: const Icon(
                      CupertinoIcons.right_chevron,
                      color: AppColors.chip1,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 28,
                  width: 28,
                  child: Lottie.asset(
                    'assets/icons/quiz_time.json',
                    repeat: true,
                    animate: true,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.timeLeft,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: AppTypography.family,
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _filledChip(String text, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        context.pushNamed('adminQuizDetails', extra: 'Science & Tech Quiz');
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.chip2,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            color: AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
