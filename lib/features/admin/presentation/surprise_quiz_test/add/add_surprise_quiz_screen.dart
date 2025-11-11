import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/surprise_quiz_test/add/widgets/surprise_quiz_duration_picker.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../common/widgets/action_success_dialog.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import 'widgets/surprise_quiz_title_fields.dart';
import 'widgets/surprise_quiz_visibility_picker.dart';
import 'widgets/surprise_quiz_points_field.dart';
import 'widgets/surprise_quiz_question_card.dart';
import 'widgets/surprise_quiz_add_button.dart';

class AddSurpriseQuizScreen extends StatefulWidget {
  const AddSurpriseQuizScreen({super.key});

  @override
  State<AddSurpriseQuizScreen> createState() => _AddSurpriseQuizScreenState();
}

class _AddSurpriseQuizScreenState extends State<AddSurpriseQuizScreen> {
  Duration quizDuration = const Duration(minutes: 15);

  int visibilityHours = 24;

  int currentQuestion = 1;
  bool hasChanges = false;
  bool importedFromVault = false;

  final pointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Add Surprise Quiz'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SurpriseQuizTitleFields(
                onChanged: () => setState(() => hasChanges = true),
              ),

              SurpriseQuizTimePicker(
                duration: quizDuration,
                onChanged: (newDuration) {
                  setState(() {
                    quizDuration = newDuration;
                    hasChanges = true;
                  });
                },
              ),

              SurpriseQuizVisibilityPicker(
                hours: visibilityHours,
                onChanged: (newHours) {
                  setState(() {
                    visibilityHours = newHours;
                    hasChanges = true;
                  });
                },
              ),

              SurpriseQuizPointsField(
                controller: pointsController,
                onChanged: () => setState(() => hasChanges = true),
              ),

              SurpriseQuizQuestionCard(
                totalQuestions: 20,
                importedFromVault: importedFromVault,
                onImportFromVault: () {
                  setState(() {
                    importedFromVault = true;
                    hasChanges = true;
                  });
                },
              ),

              const SizedBox(height: 20),

              SurpriseQuizAddButton(
                isActive: hasChanges,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => ActionSuccessDialog(
                          title: "Quiz Added!",
                          message:
                              "The surprise quiz has been added successfully.\n\n"
                              "🕓 Available for ${quizDuration.inMinutes} min\n"
                              "⏰ Visible for $visibilityHours hours",
                          onConfirm: () => Navigator.pop(context),
                        ),
                  );
                  setState(() => hasChanges = false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
