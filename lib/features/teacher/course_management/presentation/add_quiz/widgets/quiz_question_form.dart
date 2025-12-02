import 'package:flutter/material.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class QuizQuestionForm extends StatelessWidget {
  final TextEditingController qCtrl;
  final TextEditingController aCtrl;
  final TextEditingController bCtrl;
  final TextEditingController cCtrl;
  final TextEditingController dCtrl;
  final TextEditingController descCtrl;
  final ValueChanged<String> onCorrectSelected;

  const QuizQuestionForm({
    super.key,
    required this.qCtrl,
    required this.aCtrl,
    required this.bCtrl,
    required this.cCtrl,
    required this.dCtrl,
    required this.descCtrl,
    required this.onCorrectSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _field("Question", qCtrl),
        _field("A) Option", aCtrl),
        _field("B) Option", bCtrl),
        _field("C) Option", cCtrl),
        _field("D) Option", dCtrl),

        // -------------------------
        // Correct Answer Dropdown
        // -------------------------
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white54, width: 1.2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: "A",
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              dropdownColor: AppColors.primaryLight,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
              ),
              items: ["A", "B", "C", "D"]
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white,
                  ),
                ),
              ))
                  .toList(),
              onChanged: (val) {
                if (val != null) onCorrectSelected(val);
              },
            ),
          ),
        ),

        _field("Description of correct answer", descCtrl, maxLines: 3),
      ],
    );
  }

  // -------------------------
  // OUTLINE INPUT FIELD
  // -------------------------
  Widget _field(String hint, TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: AppTypography.family,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: AppTypography.family,
          color: Colors.white60,
        ),
        filled: false, // ✨ NO FILLED COLOR
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        // OUTLINE BORDER
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54, width: 1.2),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AppColors.secondaryDark, width: 1.5), // ✨ Neon border
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
