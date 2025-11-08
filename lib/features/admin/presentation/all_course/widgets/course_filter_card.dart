import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class CourseFilterCard extends StatelessWidget {
  final String selectedGroup;
  final String selectedLevel;
  final String selectedStatus;
  final Function(String, String, String) onChanged;

  const CourseFilterCard({
    super.key,
    required this.selectedGroup,
    required this.selectedLevel,
    required this.selectedStatus,
    required this.onChanged,
  });

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selected,
    Function(String) onSelect,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),

          Wrap(
            spacing: 8,
            runSpacing: 0,
            children:
                options.map((o) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: o,
                        groupValue: selected,
                        onChanged: (v) => onSelect(v!),
                        activeColor: AppColors.secondaryDark,
                        fillColor: WidgetStateProperty.resolveWith<Color>((
                          states,
                        ) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.secondaryDark;
                          }
                          return Colors.white;
                        }),
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                      ),
                      Text(
                        o,
                        style: const TextStyle(
                          fontFamily: AppTypography.family,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterSection(
            'Group',
            ['All', 'Science', 'Arts', 'Commerce'],
            selectedGroup,
            (v) => onChanged(v, selectedLevel, selectedStatus),
          ),
          _buildFilterSection(
            'Level',
            ['All', 'HSC', 'SSC'],
            selectedLevel,
            (v) => onChanged(selectedGroup, v, selectedStatus),
          ),
          _buildFilterSection(
            'Status',
            ['All', 'Approved', 'Pending', 'Rejected'],
            selectedStatus,
            (v) => onChanged(selectedGroup, selectedLevel, v),
          ),
        ],
      ),
    );
  }
}
