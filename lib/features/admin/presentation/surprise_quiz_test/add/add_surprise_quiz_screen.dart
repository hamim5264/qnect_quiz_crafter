import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';

import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../common/widgets/action_success_dialog.dart';
import '../../../../../ui/design_system/tokens/colors.dart';

import '../controller/add_surprise_quiz_controller.dart';
import '../data/add_surprise_quiz_model.dart';
import 'widgets/surprise_quiz_title_fields.dart';
import 'widgets/surprise_quiz_visibility_picker.dart';
import 'widgets/surprise_quiz_points_field.dart';
import 'widgets/surprise_quiz_question_card.dart';
import 'widgets/surprise_quiz_duration_picker.dart';

class AddSurpriseQuizScreen extends ConsumerStatefulWidget {
  const AddSurpriseQuizScreen({super.key});

  @override
  ConsumerState<AddSurpriseQuizScreen> createState() =>
      _AddSurpriseQuizScreenState();
}

class _AddSurpriseQuizScreenState extends ConsumerState<AddSurpriseQuizScreen> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final pointsCtrl = TextEditingController();

  Duration quizDuration = const Duration(minutes: 15);
  int visibilityHours = 24;
  bool hasChanges = false;
  bool isSubmitting = false;

  String selectedGroup = "HSC";
  String selectedLevel = "Science";

  List<SurpriseQuizQuestion>? imported;

  final GlobalKey<SurpriseQuizQuestionCardState> questionCardKey =
      GlobalKey<SurpriseQuizQuestionCardState>();

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    pointsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Add Surprise Quiz"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _dropdown(
                      label: "Group",
                      value: selectedGroup,
                      items: const ["HSC", "SSC"],
                      onChanged: (v) {
                        setState(() {
                          selectedGroup = v;
                          hasChanges = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _dropdown(
                      label: "Level",
                      value: selectedLevel,
                      items: const ["Science", "Arts", "Commerce"],
                      onChanged: (v) {
                        setState(() {
                          selectedLevel = v;
                          hasChanges = true;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SurpriseQuizTitleFields(
                titleController: titleCtrl,
                descriptionController: descCtrl,
                onChanged: () => setState(() => hasChanges = true),
              ),

              SurpriseQuizTimePicker(
                duration: quizDuration,
                onChanged: (d) {
                  setState(() {
                    quizDuration = d;
                    hasChanges = true;
                  });
                },
              ),

              SurpriseQuizVisibilityPicker(
                hours: visibilityHours,
                onChanged: (h) {
                  setState(() {
                    visibilityHours = h;
                    hasChanges = true;
                  });
                },
              ),

              SurpriseQuizPointsField(
                controller: pointsCtrl,
                onChanged: () => setState(() => hasChanges = true),
              ),

              const SizedBox(height: 16),

              SurpriseQuizQuestionCard(
                key: questionCardKey,
                totalQuestions: 20,
                importedQuestions: imported,
                onImportFromVault: () async {
                  final result = await context.push<List<SurpriseQuizQuestion>>(
                    '/admin/surprise/import',
                  );

                  if (result != null) {
                    setState(() {
                      imported = result;
                      hasChanges = true;
                    });
                  }
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      (hasChanges && !isSubmitting) ? _handleSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:
                      isSubmitting
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: AppLoader(size: 20),
                          )
                          : const Text(
                            "Add Quiz",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Barlow",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (questionCardKey.currentState == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Question card not ready.")));
      return;
    }

    final questions = questionCardKey.currentState!.getFinalQuestions();

    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one question.")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    final controller = ref.read(surpriseQuizControllerProvider.notifier);
    final createdBy = FirebaseAuth.instance.currentUser?.uid ?? "unknown";

    await controller.saveQuiz(
      title: titleCtrl.text.trim(),
      description: descCtrl.text.trim(),
      duration: quizDuration,
      visibilityHours: visibilityHours,
      points: int.tryParse(pointsCtrl.text.trim()) ?? 0,
      questions: questions,
      group: selectedGroup,
      level: selectedLevel,
      createdBy: createdBy,
    );

    setState(() => isSubmitting = false);

    showDialog(
      context: context,
      builder:
          (_) => ActionSuccessDialog(
            title: "Quiz Added!",
            message:
                "The surprise quiz has been added successfully.\n"
                "Duration: ${quizDuration.inMinutes} minutes\n"
                "Visible for: $visibilityHours hours",
            onConfirm: () {
              Navigator.pop(context);
              context.pop();
            },
          ),
    );

    setState(() {
      titleCtrl.clear();
      descCtrl.clear();
      pointsCtrl.clear();
      imported = null;
      hasChanges = false;
    });
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: AppColors.primaryLight,
          iconEnabledColor: Colors.white,
          value: value,
          items:
              items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontFamily: "Barlow",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (v) => onChanged(v ?? value),
        ),
      ),
    );
  }
}
