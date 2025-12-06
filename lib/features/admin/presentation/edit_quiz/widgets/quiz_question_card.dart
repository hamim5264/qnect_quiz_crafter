import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizQuestionCard extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final Function(List<Map<String, dynamic>>) onChanged;

  const QuizQuestionCard({
    super.key,
    required this.questions,
    required this.onChanged,
  });

  @override
  State<QuizQuestionCard> createState() => _QuizQuestionCardState();
}

class _QuizQuestionCardState extends State<QuizQuestionCard> {
  final PageController _pageController = PageController();
  int currentQuestion = 0;

  late List<Map<String, dynamic>> questions;

  @override
  void initState() {
    super.initState();

    questions =
        widget.questions
            .map(
              (q) => {
                "question": q["question"],
                "options": List<String>.from(q["options"]),
                "correct": q["correct"],
                "description": q["description"],
              },
            )
            .toList();
  }

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Question (${currentQuestion + 1}/${questions.length})",
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
              onPageChanged: (i) => setState(() => currentQuestion = i),
              itemBuilder: (_, index) => _buildQuestionCard(questions[index]),
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
                      ? "Next (${currentQuestion + 1}/${questions.length})"
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
    final questionController = TextEditingController(text: q["question"]);
    final descriptionController = TextEditingController(text: q["description"]);

    final ScrollController scrollController = ScrollController();

    final optionControllers =
        (q["options"] as List)
            .map<TextEditingController>((o) => TextEditingController(text: o))
            .toList();

    String correct = q["correct"];

    questionController.addListener(() {
      q["question"] = questionController.text;
      widget.onChanged(questions);
    });

    descriptionController.addListener(() {
      q["description"] = descriptionController.text;
      widget.onChanged(questions);
    });

    for (int i = 0; i < optionControllers.length; i++) {
      optionControllers[i].addListener(() {
        q["options"][i] = optionControllers[i].text.toLowerCase();
        widget.onChanged(questions);
      });
    }

    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      radius: const Radius.circular(12),
      thickness: 4,
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.only(top: 10, right: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _outlined(questionController, "Enter question...", maxLines: 2),
            const SizedBox(height: 12),

            ...List.generate(optionControllers.length, (i) {
              final label = String.fromCharCode(65 + i);
              final isCorrect = correct == label;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 14, right: 8),
                      child: Text(
                        "$label)",
                        style: const TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _outlined(
                        optionControllers[i],
                        "option $label",
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
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: correct,
                  dropdownColor: AppColors.primaryLight,
                  icon: const Icon(
                    CupertinoIcons.chevron_down,
                    color: Colors.white,
                  ),
                  isExpanded: true,
                  items:
                      ["A", "B", "C", "D"].map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                  onChanged: (v) {
                    setState(() {
                      correct = v!;
                      q["correct"] = v;
                      widget.onChanged(questions);
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 14),

            _outlined(
              descriptionController,
              "Write short explanation...",
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _outlined(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    Color filledColor = Colors.white,
    Color borderColor = Colors.black54,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: AppTypography.family,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hint,

        filled: true,
        fillColor: filledColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
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
