import 'package:flutter/material.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class SurpriseQuizVisibilityPicker extends StatelessWidget {
  final int hours;
  final ValueChanged<int> onChanged;

  const SurpriseQuizVisibilityPicker({
    super.key,
    required this.hours,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<int> visibilityOptions = [24, 48, 72];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Visible for $hours hours",
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white70,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              dropdownColor: AppColors.primaryLight,
              value: hours,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              items:
                  visibilityOptions.map((int val) {
                    return DropdownMenuItem<int>(
                      value: val,
                      child: Text(
                        "$val hours",
                        style: const TextStyle(
                          fontFamily: AppTypography.family,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: (v) => onChanged(v ?? 24),
            ),
          ),
        ],
      ),
    );
  }
}
