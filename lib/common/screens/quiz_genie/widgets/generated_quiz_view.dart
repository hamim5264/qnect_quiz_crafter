import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnect_quiz_crafter/common/widgets/action_success_dialog.dart';
import 'package:qnect_quiz_crafter/common/widgets/success_failure_dialog.dart';

import '../controllers/quiz_genie_controller.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import 'question_card.dart';

class GeneratedQuizView extends ConsumerWidget {
  final String role;

  const GeneratedQuizView({super.key, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizGenieControllerProvider);
    final quiz = state.quiz!;
    final controller = ref.read(quizGenieControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppColors.secondaryDark,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            "Perfect! I've generated a quiz on ${quiz.title.toLowerCase()}.",
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: quiz.questions.length,
          itemBuilder: (_, i) {
            return QuestionCard(number: i + 1, question: quiz.questions[i]);
          },
        ),

        const SizedBox(height: 20),

        SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  state.status == QuizGenieStatus.saving
                      ? null
                      : () async {
                        final ok = await controller.saveToPractice(
                          creatorRole: role,
                        );

                        if (context.mounted) {
                          if (ok) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ActionSuccessDialog(
                                  title: "Quiz added successfully",
                                  message:
                                      "Please check your practice section.",
                                  onConfirm: () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SuccessFailureDialog(
                                  icon: Icons.error_outline,
                                  title: "Failed to save quiz",
                                  subtitle:
                                      "Something went wrong while storing your quiz.\nPlease try again.",
                                  buttonText: "Okay",
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          }
                        }
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                "Add this quiz to practice quiz section",
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
