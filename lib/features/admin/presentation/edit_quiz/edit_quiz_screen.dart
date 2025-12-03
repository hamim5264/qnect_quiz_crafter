// import 'package:flutter/material.dart';
// import '../../../../../common/widgets/common_rounded_app_bar.dart';
// import 'widgets/quiz_title_fields.dart';
// import 'widgets/quiz_time_picker.dart';
// import 'widgets/quiz_icon_dropdown.dart';
// import 'widgets/quiz_date_fields.dart';
// import 'widgets/quiz_date_warning_card.dart';
// import 'widgets/quiz_question_card.dart';
// import 'widgets/quiz_import_button.dart';
// import 'widgets/quiz_update_button.dart';
// import '../../../../../ui/design_system/tokens/colors.dart';
// import '../../../../../ui/design_system/tokens/typography.dart';
//
// class EditQuizScreen extends StatefulWidget {
//   const EditQuizScreen({super.key});
//
//   @override
//   State<EditQuizScreen> createState() => _EditQuizScreenState();
// }
//
// class _EditQuizScreenState extends State<EditQuizScreen> {
//   DateTime startDate = DateTime(2025, 10, 10);
//   DateTime endDate = DateTime(2025, 10, 12);
//   IconData quizIcon = Icons.book_outlined;
//   Duration quizTime = const Duration(minutes: 10, seconds: 30);
//   bool hasChanges = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryDark,
//
//       appBar: const CommonRoundedAppBar(title: 'Edit Quiz'),
//
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               QuizTitleFields(
//                 onChanged: () => setState(() => hasChanges = true),
//               ),
//
//               QuizTimePicker(
//                 duration: quizTime,
//                 onChanged: (newDuration) {
//                   setState(() {
//                     quizTime = newDuration;
//                     hasChanges = true;
//                   });
//                 },
//               ),
//
//               QuizIconDropdown(
//                 selectedIcon: quizIcon,
//                 onSelect: (icon) {
//                   setState(() {
//                     quizIcon = icon;
//                     hasChanges = true;
//                   });
//                 },
//               ),
//
//               QuizDateFields(
//                 startDate: startDate,
//                 endDate: endDate,
//                 onStartChanged: (date) {
//                   setState(() {
//                     startDate = date;
//                     hasChanges = true;
//                   });
//                 },
//                 onEndChanged: (date) {
//                   setState(() {
//                     endDate = date;
//                     hasChanges = true;
//                   });
//                 },
//               ),
//
//               const QuizDateWarningCard(
//                 courseStart: '10/10/25',
//                 courseEnd: '10/12/25',
//               ),
//
//               const QuizQuestionCard(totalQuestions: 30),
//
//               const SizedBox(height: 16),
//
//               const QuizImportButton(),
//
//               const SizedBox(height: 16),
//
//               QuizUpdateButton(
//                 isActive: hasChanges,
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder:
//                         (_) => AlertDialog(
//                           backgroundColor: AppColors.primaryLight,
//                           title: const Text(
//                             'Success',
//                             style: TextStyle(
//                               fontFamily: AppTypography.family,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           content: const Text(
//                             'The quiz has been updated successfully!',
//                             style: TextStyle(fontFamily: AppTypography.family),
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: const Text('Okay'),
//                             ),
//                           ],
//                         ),
//                   );
//                   setState(() => hasChanges = false);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

import 'widgets/quiz_title_fields.dart';
import 'widgets/quiz_time_picker.dart';
import 'widgets/quiz_icon_dropdown.dart';
import 'widgets/quiz_date_fields.dart';
import 'widgets/quiz_date_warning_card.dart';
import 'widgets/quiz_question_card.dart';
import 'widgets/quiz_import_button.dart';
import 'widgets/quiz_update_button.dart';

class EditQuizScreen extends StatefulWidget {
  final String quizId;
  final String courseId;

  const EditQuizScreen({
    super.key,
    required this.quizId,
    required this.courseId,
  });

  @override
  State<EditQuizScreen> createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  Map<String, dynamic>? quiz;
  bool loading = true;

  late TextEditingController titleController;
  late TextEditingController subtitleController;

  DateTime? startDate;
  DateTime? endDate;
  IconData quizIcon = Icons.book_outlined;
  Duration quizTime = const Duration(minutes: 10);
  List<Map<String, dynamic>> questions = [];

  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    subtitleController = TextEditingController();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    final doc = await FirebaseFirestore.instance
        .collection("courses")
        .doc(widget.courseId)
        .collection("quizzes")
        .doc(widget.quizId)
        .get();

    if (!doc.exists) return;

    quiz = doc.data();

    titleController.text = quiz!["title"];
    subtitleController.text = quiz!["subtitle"];

    quizIcon = IconData(
      quiz!["icon"] ?? Icons.book.codePoint,
      fontFamily: quiz!["iconFont"] ?? "MaterialIcons",
    );

    quizTime = Duration(seconds: quiz!["time"]);

    startDate = _date(quiz!["startDate"]);
    endDate = _date(quiz!["endDate"]);

    // 🔥 Load questions
    questions = List<Map<String, dynamic>>.from(quiz!["questions"]);

    // 🔥 FIX MAP → LIST
    questions = questions.map((q) {
      return {
        "question": q["question"],
        "options": q["options"] is Map
            ? (q["options"] as Map).values.map((e) => e.toString()).toList()
            : q["options"],
        "correct": q["correct"],
        "explanation": q["explanation"],
      };
    }).toList();

    setState(() => loading = false);
  }


  DateTime _date(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.parse(v);
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: Center(
          child: AppLoader(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Edit Quiz"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              QuizTitleFields(
                titleController: titleController,
                subtitleController: subtitleController,
                onChanged: () => setState(() => hasChanges = true),
              ),

              QuizTimePicker(
                duration: quizTime,
                onChanged: (d) {
                  quizTime = d;
                  setState(() => hasChanges = true);
                },
              ),

              QuizIconDropdown(
                selectedIcon: quizIcon,
                onSelect: (icon) {
                  quizIcon = icon;
                  setState(() => hasChanges = true);
                },
              ),

              QuizDateFields(
                startDate: startDate!,
                endDate: endDate!,
                onStartChanged: (d) {
                  startDate = d;
                  setState(() => hasChanges = true);
                },
                onEndChanged: (d) {
                  endDate = d;
                  setState(() => hasChanges = true);
                },
              ),

              QuizDateWarningCard(
                courseStart: startDate.toString(),
                courseEnd: endDate.toString(),
              ),

              QuizQuestionCard(
                questions: questions,
                onChanged: (updated) {
                  questions = updated;
                  setState(() => hasChanges = true);
                },
              ),

              const SizedBox(height: 16),
              const QuizImportButton(),
              const SizedBox(height: 16),

              QuizUpdateButton(
                isActive: hasChanges,
                onPressed: _saveQuiz,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveQuiz() async {
    await FirebaseFirestore.instance
        .collection("courses")
        .doc(widget.courseId)
        .collection("quizzes")
        .doc(widget.quizId)
        .update({
      "title": titleController.text,
      "subtitle": subtitleController.text,
      "icon": quizIcon.codePoint,
      "iconFont": quizIcon.fontFamily ?? "MaterialIcons",
      "time": quizTime.inSeconds,
      "startDate": startDate!.toIso8601String(),
      "endDate": endDate!.toIso8601String(),
      "questions": questions,
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.primaryLight,
        title: const Text(
          'Success',
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Quiz updated successfully!',
          style: TextStyle(fontFamily: AppTypography.family),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    setState(() => hasChanges = false);
  }
}


