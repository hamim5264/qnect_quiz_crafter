import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class SurpriseQuizQuestionCard extends StatefulWidget {
  final int totalQuestions;
  final bool importedFromVault;
  final VoidCallback onImportFromVault;

  const SurpriseQuizQuestionCard({
    super.key,
    required this.totalQuestions,
    required this.importedFromVault,
    required this.onImportFromVault,
  });

  @override
  State<SurpriseQuizQuestionCard> createState() =>
      _SurpriseQuizQuestionCardState();
}

class _SurpriseQuizQuestionCardState extends State<SurpriseQuizQuestionCard> {
  late final PageController _pageController;
  late final List<Map<String, dynamic>> _questions;
  int _currentQuestion = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _initQuestions();
  }

  void _initQuestions() {
    _questions = List.generate(widget.totalQuestions, (i) {
      return {
        "question": TextEditingController(),
        "options": List.generate(4, (_) => TextEditingController()),
        "correct": "A",
        "desc": TextEditingController(),
        "filled": false,
      };
    });
  }

  void _updateFilledStatus(int index) {
    final q = _questions[index];
    final allFilled =
        (q["question"] as TextEditingController).text.isNotEmpty &&
        (q["options"] as List<TextEditingController>).every(
          (opt) => opt.text.isNotEmpty,
        );
    q["filled"] = allFilled;
  }

  void _importVaultQuestions() {
    for (var q in _questions) {
      q["question"].text = "Imported question from QC Vault";
      q["options"] = List.generate(
        4,
        (i) => TextEditingController(text: "Imported option ${i + 1}"),
      );
      q["correct"] = "A";
      q["desc"].text = "Imported description from vault.";
      q["filled"] = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.importedFromVault) _importVaultQuestions();

    final total = widget.totalQuestions;
    final current = _currentQuestion + 1;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                child: Column(
                  children: [
                    Text(
                      "Question $current / $total",
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 34,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: total,
                        separatorBuilder: (_, __) => const SizedBox(width: 6),
                        itemBuilder: (context, i) {
                          final isActive = i == _currentQuestion;
                          final isFilled = _questions[i]["filled"] == true;
                          return GestureDetector(
                            onTap: () {
                              _pageController.jumpToPage(i);
                              setState(() => _currentQuestion = i);
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    isActive
                                        ? AppColors.primaryLight
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      isFilled
                                          ? Colors.black45
                                          : AppColors.primaryLight,
                                  width: 1.5,
                                ),
                              ),
                              child:
                                  isFilled
                                      ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                      : Text(
                                        "${i + 1}",
                                        style: TextStyle(
                                          fontFamily: AppTypography.family,
                                          color:
                                              isActive
                                                  ? Colors.white
                                                  : Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),

              SizedBox(
                height: 440,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: total,
                  onPageChanged:
                      (index) => setState(() => _currentQuestion = index),
                  itemBuilder: (context, index) {
                    final q = _questions[index];
                    final optionCtrls =
                        q["options"] as List<TextEditingController>;
                    final scrollCtrl = ScrollController();

                    return Scrollbar(
                      thumbVisibility: true,
                      controller: scrollCtrl,
                      child: SingleChildScrollView(
                        controller: scrollCtrl,
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _outlinedTextField(
                              controller: q["question"],
                              hint: "Write question ${index + 1}",
                              maxLines: null,
                              borderColor: Colors.black54,
                              onChanged:
                                  (_) => setState(
                                    () => _updateFilledStatus(index),
                                  ),
                            ),
                            const SizedBox(height: 10),

                            ...List.generate(optionCtrls.length, (i) {
                              final label = String.fromCharCode(65 + i);
                              final isCorrect = q["correct"] == label;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 14,
                                        right: 8,
                                      ),
                                      child: Text(
                                        '$label)',
                                        style: const TextStyle(
                                          fontFamily: AppTypography.family,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: _outlinedTextField(
                                        controller: optionCtrls[i],
                                        hint: 'Option $label',
                                        borderColor:
                                            isCorrect
                                                ? AppColors.chip2
                                                : Colors.black45,
                                        fillColor:
                                            isCorrect
                                                ? AppColors.chip2.withValues(
                                                  alpha: 0.3,
                                                )
                                                : Colors.white,
                                        onChanged:
                                            (_) => setState(
                                              () => _updateFilledStatus(index),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            Container(
                              height: 48,
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                border: Border.all(
                                  color: AppColors.primaryLight,
                                  width: 1.2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: q["correct"],
                                  icon: const Icon(
                                    CupertinoIcons.chevron_down,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  dropdownColor: AppColors.primaryLight,
                                  isExpanded: true,
                                  style: const TextStyle(
                                    fontFamily: AppTypography.family,
                                    color: Colors.white,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'A',
                                      child: Text(
                                        'A',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'B',
                                      child: Text(
                                        'B',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'C',
                                      child: Text(
                                        'C',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'D',
                                      child: Text(
                                        'D',
                                        style: TextStyle(color: Colors.white),
                                      ),
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

                            _outlinedTextField(
                              controller: q["desc"],
                              hint: "Description of correct answer",
                              maxLines: 4,
                              borderColor: Colors.black45,
                              onChanged:
                                  (_) => setState(
                                    () => _updateFilledStatus(index),
                                  ),
                            ),
                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (index > 0)
                                  _pillButton(
                                    label: "Previous",
                                    background: AppColors.chip2,
                                    onTap: () {
                                      _pageController.previousPage(
                                        duration: const Duration(
                                          milliseconds: 250,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                if (index > 0) const SizedBox(width: 10),
                                _pillButton(
                                  label:
                                      (index < total - 1) ? "Next" : "Finish",
                                  background: AppColors.chip3,
                                  onTap: () {
                                    if (index < total - 1) {
                                      _pageController.nextPage(
                                        duration: const Duration(
                                          milliseconds: 250,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        OutlinedButton.icon(
          onPressed: widget.onImportFromVault,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.secondaryDark, width: 1.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          icon: const Icon(
            CupertinoIcons.arrow_down_to_line,
            color: AppColors.secondaryDark,
            size: 18,
          ),
          label: const Text(
            "Import from QC Vault",
            style: TextStyle(
              fontFamily: AppTypography.family,
              color: AppColors.secondaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _outlinedTextField({
    required TextEditingController controller,
    required String hint,
    required Color borderColor,
    Color fillColor = Colors.white,
    int? maxLines = 1,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      style: const TextStyle(
        fontFamily: AppTypography.family,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: AppTypography.family,
          color: Colors.black45,
        ),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _pillButton({
    required String label,
    required Color background,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: AppTypography.family,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
