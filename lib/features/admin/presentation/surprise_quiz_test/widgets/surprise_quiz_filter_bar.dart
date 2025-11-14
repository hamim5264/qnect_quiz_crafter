import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class SurpriseQuizFilterBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const SurpriseQuizFilterBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ["Unpublished", "Published"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          filters.map((filter) {
            final isSelected = filter == selected;
            return GestureDetector(
              onTap: () => onSelect(filter),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? AppColors.secondaryDark
                          : AppColors.primaryLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    color: isSelected ? Colors.black : Colors.white60,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
