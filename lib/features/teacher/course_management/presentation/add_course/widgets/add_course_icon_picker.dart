// lib/features/teacher/course_management/presentation/add_course/widgets/add_course_icon_picker.dart

import 'package:flutter/material.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class AddCourseIconPicker extends StatefulWidget {
  final String selectedIcon;
  final ValueChanged<String> onSelect;

  const AddCourseIconPicker({
    super.key,
    required this.selectedIcon,
    required this.onSelect,
  });

  @override
  State<AddCourseIconPicker> createState() => _AddCourseIconPickerState();
}

class _AddCourseIconPickerState extends State<AddCourseIconPicker> {
  bool showGrid = false;

  // Your 37 icons same as EditCourse
  final int iconCount = 37;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ────────────────────────────────
        // TOP PICKER TILE + HINT
        // ────────────────────────────────
        GestureDetector(
          onTap: () => setState(() => showGrid = !showGrid),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // ICON PREVIEW
                if (widget.selectedIcon.isNotEmpty &&
                    widget.selectedIcon != "Select Course Icon")
                  Image.asset(widget.selectedIcon, height: 22, width: 22),

                if (widget.selectedIcon != "Select Course Icon")
                  const SizedBox(width: 10),

                // HINT OR SELECTED ICON NAME
                Text(
                  widget.selectedIcon.isEmpty ||
                      widget.selectedIcon == "Select Course Icon"
                      ? "Select Course Icon"
                      : widget.selectedIcon.split('/').last,
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    color: widget.selectedIcon.isEmpty
                        ? Colors.white70 // hint color
                        : Colors.white,
                    fontSize: 15,
                  ),
                ),

                const Spacer(),

                Icon(
                  showGrid
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ),

        // ────────────────────────────────
        // ICON GRID POPUP
        // ────────────────────────────────
        if (showGrid)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: iconCount,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (_, index) {
                final iconPath = "assets/icons/c${index + 1}.png";
                final isSelected = widget.selectedIcon == iconPath;

                return GestureDetector(
                  onTap: () {
                    widget.onSelect(iconPath);
                    setState(() => showGrid = false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryLight
                            : Colors.white24,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? AppColors.primaryLight.withValues(alpha: 0.15)
                          : Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        iconPath,
                        fit: BoxFit.contain,
                      ),
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
