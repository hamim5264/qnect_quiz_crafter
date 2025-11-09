import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class EditCourseSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const EditCourseSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Apply Discount',
            style: TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white,
            ),
          ),
          Switch(
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.primaryLight,
            value: value,
            activeColor: AppColors.white,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
