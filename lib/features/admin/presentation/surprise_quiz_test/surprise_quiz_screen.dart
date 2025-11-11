import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/surprise_quiz_test/add/add_surprise_quiz_screen.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/surprise_quiz_test/widgets/surprise_quiz_card.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/surprise_quiz_test/widgets/surprise_quiz_filter_bar.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../common/widgets/action_success_dialog.dart';
import '../../../../../common/widgets/common_confirm_dialog.dart';

class SurpriseQuizScreen extends StatefulWidget {
  const SurpriseQuizScreen({super.key});

  @override
  State<SurpriseQuizScreen> createState() => _SurpriseQuizScreenState();
}

class _SurpriseQuizScreenState extends State<SurpriseQuizScreen> {
  String selectedFilter = "All";

  final List<Map<String, dynamic>> quizzes = List.generate(
    6,
    (i) => {
      "title": "Surprise Test ${i + 1}",
      "icon": "QZ",
      "published": i.isEven,
      "publishedDate": "10 Nov 2025",
    },
  );

  void showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => CommonConfirmDialog(
            title: title,
            message: message,
            icon: CupertinoIcons.trash,
            iconColor: Colors.white,
            confirmColor: Colors.redAccent,
            onConfirm: onConfirm,
          ),
    );
  }

  void showConfirmDialogOnPublish({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => CommonConfirmDialog(
            title: title,
            message: message,
            icon: CupertinoIcons.paperplane,
            iconColor: Colors.white,
            confirmColor: AppColors.chip2,
            onConfirm: onConfirm,
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
      appBar: const CommonRoundedAppBar(title: 'Surprise Quizzes'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SurpriseQuizFilterBar(
                selected: selectedFilter,
                onSelect: (value) => setState(() => selectedFilter = value),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: GridView.builder(
                  itemCount: quizzes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.88,
                  ),
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    return SurpriseQuizCard(
                      title: quiz["title"] as String,
                      icon: quiz["icon"] as String,
                      isPublished: quiz["published"] as bool,
                      publishedDate: quiz["publishedDate"] as String,
                      onPublish: () {
                        showConfirmDialogOnPublish(
                          title: "Publish Quiz",
                          message:
                              "Are you sure you want to publish this surprise quiz?",
                          onConfirm: () {
                            setState(() => quiz["published"] = true);
                            showSuccessDialog(
                              "Published Successfully",
                              "This surprise quiz is now live for students.",
                            );
                          },
                        );
                      },
                      onDelete: () {
                        showConfirmDialog(
                          title: "Delete Quiz",
                          message:
                              "Are you sure you want to delete this surprise quiz?",
                          onConfirm: () {
                            showSuccessDialog(
                              "Deleted Successfully",
                              "This quiz has been removed.",
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSurpriseQuizScreen()),
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
