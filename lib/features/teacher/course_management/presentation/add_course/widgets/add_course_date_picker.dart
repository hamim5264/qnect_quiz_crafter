// lib/features/teacher/course_management/presentation/add_course/widgets/add_course_date_picker.dart

import 'package:flutter/material.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';


class AddCourseDatePicker extends StatelessWidget {
  final String hint;
  final DateTime date;
  final ValueChanged<DateTime> onSelect;

  const AddCourseDatePicker({
    super.key,
    required this.hint,
    required this.date,
    required this.onSelect,
  });

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.secondaryDark,
            surface: AppColors.primaryLight,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) onSelect(picked);
  }

  @override
  Widget build(BuildContext context) {
    final formatted = "${date.day}/${date.month}/${date.year}";

    return GestureDetector(
      onTap: () => _pick(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatted,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: AppTypography.family,
              ),
            ),
            const Icon(Icons.calendar_month, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
