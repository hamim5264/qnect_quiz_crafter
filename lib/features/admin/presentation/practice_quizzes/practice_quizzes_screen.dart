import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/practice_quizzes/widgets/quiz_card.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/practice_quizzes/widgets/quiz_date_filter.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/practice_quizzes/widgets/quiz_filter_bar.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../../../../../common/widgets/action_success_dialog.dart';

class PracticeQuizzesScreen extends StatefulWidget {
  const PracticeQuizzesScreen({super.key});

  @override
  State<PracticeQuizzesScreen> createState() => _PracticeQuizzesScreenState();
}

class _PracticeQuizzesScreenState extends State<PracticeQuizzesScreen> {
  String selectedFilter = "Admin’s";
  String dateFilter = "All";

  final quizzes = List.generate(
    6,
    (i) => {"title": "Parts of Speech", "icon": "En", "published": i.isEven},
  );

  void showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: AppColors.primaryLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: Text(
              message,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white70,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void showSuccessDialog(String title, String message) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Practice Quizzes"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              QuizFilterBar(
                selectedFilter: selectedFilter,
                onChanged: (v) => setState(() => selectedFilter = v),
              ),
              const SizedBox(height: 12),
              QuizDateFilter(
                dateFilter: dateFilter,
                onFilterChange: (v) => setState(() => dateFilter = v),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: quizzes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    return QuizCard(
                      title: quiz["title"] as String,
                      icon: quiz["icon"] as String,
                      isPublished: quiz["published"] as bool,
                      onPublish: () {
                        showConfirmDialog(
                          title: "Publish Quiz",
                          message:
                              "Are you sure you want to publish this quiz?",
                          onConfirm: () {
                            setState(() => quiz["published"] = true);
                            showSuccessDialog(
                              "Published Successfully",
                              "This quiz is now available for learners.",
                            );
                          },
                        );
                      },
                      onDelete: () {
                        showConfirmDialog(
                          title: "Delete Quiz",
                          message:
                              "Are you sure you want to delete this quiz permanently?",
                          onConfirm: () {
                            showSuccessDialog(
                              "Quiz Deleted",
                              "The quiz has been deleted successfully.",
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
