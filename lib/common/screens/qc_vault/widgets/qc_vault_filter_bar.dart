import 'package:flutter/material.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';

class QCVaultFilterBar extends StatelessWidget {
  final String selectedGroup;
  final String selectedLevel;
  final ValueChanged<String> onGroupChanged;
  final ValueChanged<String> onLevelChanged;

  const QCVaultFilterBar({
    super.key,
    required this.selectedGroup,
    required this.selectedLevel,
    required this.onGroupChanged,
    required this.onLevelChanged,
  });

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
    required String hint,
  }) {
    return Expanded(
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            hint: Text(
              hint,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            dropdownColor: AppColors.primaryLight,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white,
              fontSize: 14,
            ),
            isExpanded: true,
            items:
                items
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(
                            fontFamily: AppTypography.family,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                    .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildDropdown(
            value: selectedGroup,
            items: const ['HSC', 'SSC'],
            onChanged: onGroupChanged,
            hint: 'Group',
          ),
          const SizedBox(width: 10),
          _buildDropdown(
            value: selectedLevel,
            items: const ['All', 'Science', 'Arts', 'Commerce'],
            onChanged: onLevelChanged,
            hint: 'Level',
          ),
        ],
      ),
    );
  }
}
