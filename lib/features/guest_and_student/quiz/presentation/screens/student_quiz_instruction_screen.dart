import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StudentQuizInstructionScreen extends StatelessWidget {
  final String quizId;
  final String courseId;
  final String title;
  final int durationSeconds;
  final List<Map<String, dynamic>> questions;

  const StudentQuizInstructionScreen({
    super.key,
    required this.quizId,
    required this.courseId,
    required this.title,
    required this.durationSeconds,
    required this.questions,
  });

  int get _minutes => (durationSeconds / 60).ceil();

  @override
  Widget build(BuildContext context) {
    final totalQuestions = questions.length;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryDark,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.back,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 28),
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white30, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 52,
                                width: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryDark,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  CupertinoIcons.question_circle_fill,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: AppTypography.family,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      "Read the rules carefully before starting.",
                                      style: TextStyle(
                                        fontFamily: AppTypography.family,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: [
                              _summaryTile(
                                icon: CupertinoIcons.doc_on_doc,
                                label: "$totalQuestions Questions",
                                subtitle: "1 point each",
                              ),
                              const SizedBox(width: 12),
                              _summaryTile(
                                icon: CupertinoIcons.time,
                                label: "$_minutes Minutes",
                                subtitle: "Total duration",
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),
                          const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                          const SizedBox(height: 10),

                          const Text(
                            "Exam Instructions",
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.chip1,
                            ),
                          ),
                          const SizedBox(height: 10),

                          const Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                "• 1 mark awarded for a correct answer, no negative marking.\n"
                                "• Tap on an option to select / change your answer.\n"
                                "• You can move between questions anytime.\n"
                                "• Do not take screenshots or screen recordings while attempting.\n"
                                "• If time is over, your current answers will be submitted automatically.\n"
                                "• If you go back from the quiz, it will be submitted immediately.",
                                style: TextStyle(
                                  fontFamily: AppTypography.family,
                                  fontSize: 13,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryLight,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: () {
                                context.pushNamed(
                                  'studentQuizAttempt',
                                  extra: {
                                    "quizId": quizId,
                                    "courseId": courseId,
                                    "title": title,
                                    "durationSeconds": durationSeconds,
                                    "questions": questions,
                                  },
                                );
                              },
                              child: const Text(
                                "Start Quiz",
                                style: TextStyle(
                                  fontFamily: AppTypography.family,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryTile({
    required IconData icon,
    required String label,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: AppColors.chip3,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
