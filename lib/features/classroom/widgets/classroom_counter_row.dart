import 'package:flutter/material.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';

class ClassroomCounterRow extends StatelessWidget {
  final int? teachers;
  final int? students;
  final int? enrolled;

  const ClassroomCounterRow({
    super.key,
    this.teachers,
    this.students,
    this.enrolled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _card("Teachers", teachers),
          const SizedBox(width: 10),
          _card("Students", students),
          if (enrolled != null) ...[
            const SizedBox(width: 10),
            _card("Enrolled", enrolled),
          ],
        ],
      ),
    );
  }

  Widget _card(String title, int? value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value?.toString() ?? "...",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
