import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizQuestionCard extends StatefulWidget {
  final int totalQuestions;

  const QuizQuestionCard({super.key, required this.totalQuestions});

  @override
  State<QuizQuestionCard> createState() => _QuizQuestionCardState();
}

class _QuizQuestionCardState extends State<QuizQuestionCard> {
  final PageController _pageController = PageController();
  int currentQuestion = 0;

  List<Map<String, dynamic>> questions = [
    {
      "question": "In “She quickly finished her homework,” what is quickly?",
      "options": ["noun", "verb", "adjective", "adverb"],
      "correct": "D",
      "description":
          "“Quickly” modifies the verb “finished”, so it is an adverb.",
    },
    {
      "question": "Which of the following is a conjunction?",
      "options": ["and", "run", "beautiful", "apple"],
      "correct": "A",
      "description": "‘And’ connects words or clauses — it’s a conjunction.",
    },
    {
      "question": "The main unit that performs calculations in a computer is—",
      "options": ["control unit", "memory unit", "alu", "input unit"],
      "correct": "C",
      "description":
          "Arithmetic Logic Unit (ALU) performs mathematical and logical operations.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Question (${currentQuestion + 1}/${widget.totalQuestions})",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Divider(thickness: 1, color: Colors.black45),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: questions.length,
              onPageChanged: (index) => setState(() => currentQuestion = index),
              itemBuilder: (context, index) {
                final q = questions[index];
                return _buildQuestionCard(q);
              },
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              questions.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 6,
                width: currentQuestion == i ? 20 : 8,
                decoration: BoxDecoration(
                  color:
                      currentQuestion == i ? AppColors.chip2 : AppColors.chip1,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentQuestion > 0)
                ElevatedButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.chip2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Previous",
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),

              if (currentQuestion > 0) const SizedBox(width: 10),

              ElevatedButton(
                onPressed: () {
                  if (currentQuestion < questions.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      currentQuestion < questions.length - 1
                          ? AppColors.chip3
                          : AppColors.primaryLight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  currentQuestion < questions.length - 1
                      ? "Next (${currentQuestion + 1}/${widget.totalQuestions})"
                      : "Finish",
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> q) {
    final TextEditingController questionController = TextEditingController(
      text: q["question"],
    );
    final ScrollController scrollController = ScrollController();
    final List<TextEditingController> optionControllers =
        (q["options"] as List)
            .map((e) => TextEditingController(text: e))
            .toList();
    String correctAnswer = q["correct"];
    final TextEditingController descriptionController = TextEditingController(
      text: q["description"],
    );

    @override
    void dispose() {
      scrollController.dispose();
      super.dispose();
    }

    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      radius: const Radius.circular(12),
      thickness: 4,
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.only(right: 6, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _outlinedTextField(
              controller: questionController,
              hint: 'Enter question...',
              maxLines: 2,
            ),
            const SizedBox(height: 12),

            ...List.generate(optionControllers.length, (index) {
              final label = String.fromCharCode(65 + index);
              final isCorrect = correctAnswer == label;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 14, right: 8),
                      child: Text(
                        '$label)',
                        style: const TextStyle(
                          fontFamily: AppTypography.family,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _outlinedTextField(
                        controller: optionControllers[index],
                        hint: 'option $label',
                        filledColor:
                            isCorrect
                                ? AppColors.chip2.withValues(alpha: 0.3)
                                : Colors.white,
                        borderColor:
                            isCorrect ? AppColors.chip2 : Colors.black45,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 6),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                border: Border.all(color: Colors.white12, width: 1.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: correctAnswer,
                    icon: const Icon(
                      CupertinoIcons.chevron_down,
                      color: Colors.white,
                      size: 18,
                    ),
                    dropdownColor: AppColors.primaryLight,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'A',
                        child: Text('A', style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: 'B',
                        child: Text('B', style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: 'C',
                        child: Text('C', style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: 'D',
                        child: Text('D', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    onChanged: (v) {
                      setState(() {
                        q["correct"] = v ?? "A";
                      });
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            _outlinedTextField(
              controller: descriptionController,
              hint: 'Write short explanation...',
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _outlinedTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    Color filledColor = Colors.white,
    Color borderColor = Colors.black54,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: AppTypography.family,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: AppTypography.family,
          color: Colors.black45,
        ),
        filled: true,
        fillColor: filledColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.4),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
