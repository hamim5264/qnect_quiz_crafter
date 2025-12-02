// lib/features/teacher/course_management/presentation/add_quiz/widgets/quiz_icon_picker.dart

import 'package:flutter/material.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class QuizIconPicker extends StatefulWidget {
  final IconData? selectedIcon; // nullable so default works
  final ValueChanged<IconData> onIconSelected;

  const QuizIconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  State<QuizIconPicker> createState() => _QuizIconPickerState();
}

class _QuizIconPickerState extends State<QuizIconPicker> {
  bool opened = false;

  // Final recommended material education icons
  final List<IconData> icons = const [
    Icons.menu_book_rounded,
    Icons.lightbulb_outline,
    Icons.school_rounded,
    Icons.quiz_rounded,
    Icons.tips_and_updates_rounded,
    Icons.auto_stories_rounded,
    Icons.history_edu_rounded,
    Icons.bookmark_rounded,
    Icons.edit_note_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final selected = widget.selectedIcon;

    return Column(
      children: [
        // ------------------ SELECTED TILE ------------------
        GestureDetector(
          onTap: () => setState(() => opened = !opened),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.white60, width: 1.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  selected ?? Icons.help_outline,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  selected == null ? "Select Quiz Icon" : "Icon Selected",
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                Icon(
                  opened ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white70,
                  size: 24,
                ),
              ],
            ),
          ),
        ),

        // ------------------ ICON GRID ------------------
        if (opened)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: icons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) {
                final icon = icons[i];
                final isSelected = icon == selected;

                return GestureDetector(
                  onTap: () {
                    widget.onIconSelected(icon);
                    setState(() => opened = false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.secondaryDark
                          : Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.white30,
                        width: 1.2,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.black : Colors.white,
                      size: 26,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
