// lib/features/teacher/course_management/presentation/add_quiz/widgets/quiz_question_card.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class QuizQuestionCard extends StatefulWidget {
  /// Called every time questions list changes.
  /// Each item: {
  ///   "question": String,
  ///   "options": {"A":..., "B":..., "C":..., "D":...},
  ///   "correct": "A"/"B"/"C"/"D",
  ///   "description": String,
  /// }
  final ValueChanged<List<Map<String, dynamic>>> onQuestionsChanged;

  const QuizQuestionCard({
    super.key,
    required this.onQuestionsChanged,
  });

  @override
  State<QuizQuestionCard> createState() => _QuizQuestionCardState();
}

class _QuestionControllers {
  final TextEditingController question = TextEditingController();
  final TextEditingController a = TextEditingController();
  final TextEditingController b = TextEditingController();
  final TextEditingController c = TextEditingController();
  final TextEditingController d = TextEditingController();
  final TextEditingController desc = TextEditingController();
  String correct = "A";
}

class _QuizQuestionCardState extends State<QuizQuestionCard> {
  final PageController _pageController = PageController();
  final List<_QuestionControllers> _questions = [_QuestionControllers()];

  int _currentIndex = 0;

  @override
  void dispose() {
    for (final q in _questions) {
      q.question.dispose();
      q.a.dispose();
      q.b.dispose();
      q.c.dispose();
      q.d.dispose();
      q.desc.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  bool _isCurrentValid() {
    final q = _questions[_currentIndex];
    return q.question.text.trim().isNotEmpty &&
        q.a.text.trim().isNotEmpty &&
        q.b.text.trim().isNotEmpty &&
        q.c.text.trim().isNotEmpty &&
        q.d.text.trim().isNotEmpty &&
        q.desc.text.trim().isNotEmpty &&
        (q.correct == "A" ||
            q.correct == "B" ||
            q.correct == "C" ||
            q.correct == "D");
  }

  void _notifyParent() {
    final list = _questions
        .where((q) =>
    q.question.text.trim().isNotEmpty &&
        q.a.text.trim().isNotEmpty &&
        q.b.text.trim().isNotEmpty &&
        q.c.text.trim().isNotEmpty &&
        q.d.text.trim().isNotEmpty &&
        q.desc.text.trim().isNotEmpty)
        .map((q) => {
      "question": q.question.text.trim(),
      "options": {
        "A": q.a.text.trim(),
        "B": q.b.text.trim(),
        "C": q.c.text.trim(),
        "D": q.d.text.trim(),
      },
      "correct": q.correct,
      "description": q.desc.text.trim(),
    })
        .toList();

    widget.onQuestionsChanged(list);
  }

  void _goNext() {
    if (!_isCurrentValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill question, all options, correct answer & description.",
          ),
        ),
      );
      return;
    }

    if (_currentIndex == _questions.length - 1) {
      _questions.add(_QuestionControllers());
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    setState(() => _currentIndex++);
    _notifyParent();
  }

  void _goBack() {
    if (_currentIndex == 0) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    setState(() => _currentIndex--);
    _notifyParent();
  }

  @override
  Widget build(BuildContext context) {
    final total = _questions.length.toString().padLeft(2, '0');

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8D3A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                "Total Question : $total",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 360,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _questions.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                final q = _questions[index];
                return _buildQuestionPage(q, index);
              },
            ),
          ),

          const SizedBox(height: 14),

          // Import from QC Vault (inside card)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Import from QC Vault (TODO)"),
                  ),
                );
              },
              icon: const Icon(
                CupertinoIcons.cloud_download,
                color: Colors.black,
                size: 18,
              ),
              label: const Text(
                "Import From QC Vault",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryDark,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Back / Next row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back
              Expanded(
                child: OutlinedButton(
                  onPressed: _currentIndex == 0 ? null : _goBack,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _currentIndex == 0
                          ? Colors.grey.shade400
                          : AppColors.chip3,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Back",
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: _currentIndex == 0
                          ? Colors.grey.shade500
                          : AppColors.chip3,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Next
              Expanded(
                child: ElevatedButton(
                  onPressed: _goNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentIndex < _questions.length - 1
                        ? "Next (${_currentIndex + 1}/${_questions.length})"
                        : "Next",
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPage(_QuestionControllers q, int index) {
    return Scrollbar(
      radius: const Radius.circular(10),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 4, top: 12, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _outlinedTextField(
              controller: q.question,
              hint: "Question",
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            _optionField(label: "A)", controller: q.a),
            _optionField(label: "B)", controller: q.b),
            _optionField(label: "C)", controller: q.c),
            _optionField(label: "D)", controller: q.d),
            const SizedBox(height: 6),

            // Correct answer dropdown
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.chip2, width: 1.5),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: q.correct,
                  icon: const Icon(
                    CupertinoIcons.chevron_down,
                    size: 18,
                    color: AppColors.chip2,
                  ),
                  isExpanded: true,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.black87,
                  ),
                  items: const [
                    DropdownMenuItem(value: "A", child: Text("A")),
                    DropdownMenuItem(value: "B", child: Text("B")),
                    DropdownMenuItem(value: "C", child: Text("C")),
                    DropdownMenuItem(value: "D", child: Text("D")),
                  ],
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() {
                      q.correct = val;
                    });
                    _notifyParent();
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            _outlinedTextField(
              controller: q.desc,
              hint: "Description of correct answer",
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14, right: 8),
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: _outlinedTextField(
              controller: controller,
              hint: "Option $label",
            ),
          ),
        ],
      ),
    );
  }

  Widget _outlinedTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
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
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black45, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.4),
        ),
      ),
      onChanged: (_) => _notifyParent(),
    );
  }
}
