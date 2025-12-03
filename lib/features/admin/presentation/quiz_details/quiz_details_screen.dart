// import 'package:flutter/material.dart';
// import '../../../../../common/widgets/common_rounded_app_bar.dart';
// import '../../../../../ui/design_system/tokens/colors.dart';
// import 'widgets/quiz_details_header.dart';
// import 'widgets/quiz_info_card.dart';
// import 'widgets/quiz_instructions_list.dart';
//
// class QuizDetailsScreen extends StatelessWidget {
//   const QuizDetailsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryDark,
//       appBar: const CommonRoundedAppBar(title: "Quiz Details"),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: const [
//               QuizDetailsHeader(
//                 title: "General Knowledge",
//                 subtitle: "No Points Will Be Added In Free Mode",
//                 icon: Icons.lightbulb_outline,
//               ),
//               SizedBox(height: 20),
//               QuizInfoCard(totalQuestions: 10, durationMinutes: 15),
//               SizedBox(height: 16),
//               QuizInstructionsList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../ui/design_system/tokens/colors.dart';

import 'widgets/quiz_details_header.dart';
import 'widgets/quiz_info_card.dart';
import 'widgets/quiz_instructions_list.dart';

class QuizDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> quiz;   // 🔥 incoming quiz data map

  const QuizDetailsScreen({
    super.key,
    required this.quiz,
  });

  // 🔥 Convert seconds → minutes safely
  int _convertSecondsToMinutes(dynamic value) {
    if (value == null) return 0;

    if (value is int) {
      return (value / 60).round();
    }

    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return (parsed / 60).round();
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    // Extract questions
    final questions = quiz["questions"] as List? ?? [];

    // Convert "time" to minutes
    final durationMinutes = _convertSecondsToMinutes(quiz["time"]);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Quiz Details"),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔥 HEADER UI
              QuizDetailsHeader(
                title: quiz["title"] ?? "Untitled Quiz",
                subtitle: quiz["subtitle"] ?? "No subtitle",
                iconValue: quiz["icon"] ?? Icons.help.codePoint,
                iconFont: quiz["iconFont"] ?? "MaterialIcons",
              ),

              const SizedBox(height: 20),

              // 🔥 INFO CARD (Questions + Time)
              QuizInfoCard(
                totalQuestions: questions.length,
                durationMinutes: durationMinutes,
              ),

              const SizedBox(height: 16),

              // 🔥 INSTRUCTIONS
              const QuizInstructionsList(),
            ],
          ),
        ),
      ),
    );
  }
}

