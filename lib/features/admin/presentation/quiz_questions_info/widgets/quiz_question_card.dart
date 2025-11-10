import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizQuestionCard extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const QuizQuestionCard({
    super.key,
    required this.questions,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final total = questions.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 80, top: 90),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              left: 20,
              right: 20,
              bottom: 6,
            ),
            child: SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: total,
                itemBuilder: (context, index) {
                  final isActive = index == currentIndex;
                  return GestureDetector(
                    onTap: () => controller.jumpToPage(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color:
                              isActive ? AppColors.chip1 : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.white : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth / total;
              return Stack(
                children: [
                  Container(height: 2, color: Colors.black12),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    left: currentIndex * width,
                    child: Container(
                      width: width,
                      height: 2,
                      color: AppColors.chip1,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),

          Expanded(
            child: PageView.builder(
              controller: controller,
              onPageChanged: onPageChanged,
              itemCount: total,
              itemBuilder: (context, index) {
                final q = questions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryDark.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          q["question"],
                          style: const TextStyle(
                            fontFamily: AppTypography.family,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(q["options"].length, (i) {
                        final isCorrect = i == q["correct"];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                isCorrect
                                    ? AppColors.primaryLight.withValues(
                                      alpha: 0.7,
                                    )
                                    : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color:
                                      isCorrect
                                          ? AppColors.primaryLight
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  String.fromCharCode(65 + i),
                                  style: TextStyle(
                                    fontFamily: AppTypography.family,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isCorrect ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  q["options"][i],
                                  style: TextStyle(
                                    fontFamily: AppTypography.family,
                                    fontSize: 14.5,
                                    color:
                                        isCorrect
                                            ? Colors.white
                                            : Colors.black87,
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
            ),
          ),
        ],
      ),
    );
  }
}
