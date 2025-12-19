import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import 'package:qnect_quiz_crafter/common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StudentQuizDetailsScreen extends StatefulWidget {
  final String quizId;
  final String courseId;
  final String title;
  final List questions;
  final String attemptId;

  const StudentQuizDetailsScreen({
    super.key,
    required this.quizId,
    required this.courseId,
    required this.title,
    required this.questions,
    required this.attemptId,
  });

  @override
  State<StudentQuizDetailsScreen> createState() =>
      _StudentQuizDetailsScreenState();
}

class _StudentQuizDetailsScreenState extends State<StudentQuizDetailsScreen> {
  int currentIndex = 0;
  List<dynamic> userAnswers = [];
  int correct = 0;
  int wrong = 0;

  @override
  void initState() {
    super.initState();
    _loadAttempt();
  }

  Future<void> _loadAttempt() async {
    final snap =
        await FirebaseFirestore.instance
            .collection("courses")
            .doc(widget.courseId)
            .collection("quizzes")
            .doc(widget.quizId)
            .collection("attempts")
            .doc(widget.attemptId)
            .get();

    final data = snap.data() ?? {};

    userAnswers = data["answers"] ?? [];

    correct = data["points"] ?? 0;
    wrong = (widget.questions.length - correct);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (userAnswers.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: const Center(child: AppLoader()),
      );
    }

    final question = widget.questions[currentIndex];
    final correctOption = (question["correct"] ?? "").toString().toUpperCase();
    final userChoice = userAnswers[currentIndex];

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CommonRoundedAppBar(title: "Quiz Details"),

      body: Column(
        children: [
          _buildSummaryCard(),
          _buildQuestionIndexStrip(),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildQuestionCard(
                question: question,
                userChoice: userChoice,
                correctChoice: correctOption,
              ),
            ),
          ),

          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white12,
          width: 1,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text("${widget.questions.length} Questions"),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _summaryPill("Right Answer", correct, Colors.green.shade100),
              _summaryPill("Wrong Answer", wrong, Colors.red.shade200),
              _summaryPill(
                "Total QN",
                widget.questions.length,
                Colors.yellow.shade200,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryPill(String title, int value, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 11,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionIndexStrip() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: widget.questions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final isActive = (i == currentIndex);
          return GestureDetector(
            onTap: () => setState(() => currentIndex = i),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.secondaryDark : Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                (i + 1).toString().padLeft(2, '0'),
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.black : Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionCard({
    required Map question,
    required String? userChoice,
    required String correctChoice,
  }) {
    final options = (question["options"] as Map).cast<String, dynamic>();
    final explanation = question["description"] ?? "";

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question["question"],
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.chip1,
            ),
          ),

          const SizedBox(height: 18),

          ...options.entries.map((entry) {
            final label = entry.key;
            final text = entry.value;

            bool isCorrect = (label == correctChoice);
            bool isUserWrong =
                (label == userChoice && userChoice != correctChoice);

            Color bg;
            Color textColor;

            if (isCorrect) {
              bg = Colors.green.shade200;
              textColor = Colors.black;
            } else if (isUserWrong) {
              bg = Colors.red.shade300;
              textColor = Colors.white;
            } else {
              bg = const Color(0xFFF2F2F2);
              textColor = Colors.black87;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text.toString().toUpperCase(),
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.lightbulb_fill, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    explanation,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    final bool isFirst = currentIndex == 0;
    final bool isLast = currentIndex == widget.questions.length - 1;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap:
                  isFirst
                      ? null
                      : () {
                        setState(() => currentIndex--);
                      },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isFirst ? Colors.white24 : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                child: Center(
                  child: Text(
                    "Previous",
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.bold,
                      color: isFirst ? Colors.black45 : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isLast) {
                  setState(() => currentIndex++);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isLast ? Colors.white24 : AppColors.secondaryDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    isLast ? "Done" : "Next",
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.bold,
                      color: isLast ? Colors.black45 : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
