import 'package:flutter/material.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import 'widgets/quiz_details_header.dart';
import 'widgets/quiz_info_card.dart';
import 'widgets/quiz_instructions_list.dart';

class QuizDetailsScreen extends StatelessWidget {
  const QuizDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Quiz Details"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              QuizDetailsHeader(
                title: "General Knowledge",
                subtitle: "No Points Will Be Added In Free Mode",
                icon: Icons.lightbulb_outline,
              ),
              SizedBox(height: 20),
              QuizInfoCard(totalQuestions: 10, durationMinutes: 15),
              SizedBox(height: 16),
              QuizInstructionsList(),
            ],
          ),
        ),
      ),
    );
  }
}
