// lib/features/teacher/course_management/presentation/add_course/widgets/add_course_dropdown.dart

import 'package:flutter/material.dart';

import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class AddCourseDropdown extends StatelessWidget {
  final String hint;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const AddCourseDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70),
          dropdownColor: AppColors.primaryLight,
          isExpanded: true,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 16,
            color: Colors.white,
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: AppTypography.family,
              ),
            ),
          ))
              .toList(),
          onChanged: (v) => onChanged(v!),
          hint: Text(
            hint,
            style: const TextStyle(
              color: Colors.white60,
              fontFamily: AppTypography.family,
            ),
          ),
        ),
      ),
    );
  }
}
