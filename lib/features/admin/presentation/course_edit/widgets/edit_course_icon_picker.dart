import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class EditCourseIconPicker extends StatefulWidget {
  final String selectedIcon;
  final ValueChanged<String> onIconSelected;

  const EditCourseIconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  State<EditCourseIconPicker> createState() => _EditCourseIconPickerState();
}

class _EditCourseIconPickerState extends State<EditCourseIconPicker> {
  bool showGrid = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => showGrid = !showGrid),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (widget.selectedIcon.isNotEmpty &&
                        widget.selectedIcon != 'Select Course Icon')
                      Image.asset(widget.selectedIcon, height: 22, width: 22),
                    if (widget.selectedIcon != 'Select Course Icon')
                      const SizedBox(width: 8),
                    Text(
                      widget.selectedIcon == 'Select Course Icon'
                          ? 'Select Course Icon'
                          : widget.selectedIcon.split('/').last,
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Icon(
                  showGrid
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        if (showGrid)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(top: 12, bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 37,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final iconPath = 'assets/icons/c${index + 1}.png';
                final isSelected = widget.selectedIcon == iconPath;

                return GestureDetector(
                  onTap: () {
                    widget.onIconSelected(iconPath);
                    setState(() => showGrid = false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.primaryLight
                                : Colors.white24,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color:
                          isSelected
                              ? AppColors.primaryLight.withValues(alpha: 0.15)
                              : Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(iconPath, fit: BoxFit.contain),
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
