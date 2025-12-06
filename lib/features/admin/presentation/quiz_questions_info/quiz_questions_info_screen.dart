import 'package:flutter/material.dart';
import '../../../../../common/widgets/common_curved_background.dart';
import 'widgets/quiz_questions_header.dart';
import 'widgets/quiz_question_card.dart';
import 'widgets/quiz_bottom_nav.dart';

class QuizQuestionsInfoScreen extends StatefulWidget {
  final String quizTitle;
  final Duration quizDuration;
  final List<Map<String, dynamic>> questions;

  const QuizQuestionsInfoScreen({
    super.key,
    required this.quizTitle,
    required this.quizDuration,
    required this.questions,
  });

  @override
  State<QuizQuestionsInfoScreen> createState() =>
      _QuizQuestionsInfoScreenState();
}

class _QuizQuestionsInfoScreenState extends State<QuizQuestionsInfoScreen> {
  int currentQuestion = 0;
  final PageController _pageController = PageController();

  late List<Map<String, dynamic>> questions;

  @override
  void initState() {
    super.initState();
    questions = widget.questions;
  }

  void goTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => currentQuestion = index);
  }

  @override
  Widget build(BuildContext context) {
    final total = questions.length;

    return Scaffold(
      body: Stack(
        children: [
          const CommonCurvedBackground(),
          SafeArea(
            child: Column(
              children: [
                QuizQuestionsHeader(
                  quizTitle: widget.quizTitle,
                  quizDuration: widget.quizDuration,
                ),

                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      QuizQuestionCard(
                        questions: questions,
                        controller: _pageController,
                        currentIndex: currentQuestion,
                        onPageChanged:
                            (i) => setState(() => currentQuestion = i),
                      ),

                      QuizBottomNav(
                        isLast: currentQuestion == total - 1,
                        onPrevious:
                            () =>
                                goTo((currentQuestion - 1).clamp(0, total - 1)),
                        onNext:
                            () =>
                                goTo((currentQuestion + 1).clamp(0, total - 1)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
