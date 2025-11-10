import 'package:flutter/material.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import 'widgets/quiz_title_fields.dart';
import 'widgets/quiz_time_picker.dart';
import 'widgets/quiz_icon_dropdown.dart';
import 'widgets/quiz_date_fields.dart';
import 'widgets/quiz_date_warning_card.dart';
import 'widgets/quiz_question_card.dart';
import 'widgets/quiz_import_button.dart';
import 'widgets/quiz_update_button.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class EditQuizScreen extends StatefulWidget {
  const EditQuizScreen({super.key});

  @override
  State<EditQuizScreen> createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  DateTime startDate = DateTime(2025, 10, 10);
  DateTime endDate = DateTime(2025, 10, 12);
  IconData quizIcon = Icons.book_outlined;
  Duration quizTime = const Duration(minutes: 10, seconds: 30);
  bool hasChanges = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,

      appBar: const CommonRoundedAppBar(title: 'Edit Quiz'),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              QuizTitleFields(
                onChanged: () => setState(() => hasChanges = true),
              ),

              QuizTimePicker(
                duration: quizTime,
                onChanged: (newDuration) {
                  setState(() {
                    quizTime = newDuration;
                    hasChanges = true;
                  });
                },
              ),

              QuizIconDropdown(
                selectedIcon: quizIcon,
                onSelect: (icon) {
                  setState(() {
                    quizIcon = icon;
                    hasChanges = true;
                  });
                },
              ),

              QuizDateFields(
                startDate: startDate,
                endDate: endDate,
                onStartChanged: (date) {
                  setState(() {
                    startDate = date;
                    hasChanges = true;
                  });
                },
                onEndChanged: (date) {
                  setState(() {
                    endDate = date;
                    hasChanges = true;
                  });
                },
              ),

              const QuizDateWarningCard(
                courseStart: '10/10/25',
                courseEnd: '10/12/25',
              ),

              const QuizQuestionCard(totalQuestions: 30),

              const SizedBox(height: 16),

              const QuizImportButton(),

              const SizedBox(height: 16),

              QuizUpdateButton(
                isActive: hasChanges,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          backgroundColor: AppColors.primaryLight,
                          title: const Text(
                            'Success',
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: const Text(
                            'The quiz has been updated successfully!',
                            style: TextStyle(fontFamily: AppTypography.family),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Okay'),
                            ),
                          ],
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
