import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class LeaderboardFilterCard extends StatelessWidget {
  final String userRole;
  final String selectedGroup;
  final String selectedLevel;
  final String selectedCourse;
  final ValueChanged<String> onGroupChanged;
  final ValueChanged<String> onLevelChanged;
  final ValueChanged<String> onCourseChanged;

  const LeaderboardFilterCard({
    super.key,
    required this.userRole,
    required this.selectedGroup,
    required this.selectedLevel,
    required this.selectedCourse,
    required this.onGroupChanged,
    required this.onLevelChanged,
    required this.onCourseChanged,
  });

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
    required String hint,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 1,
        ),
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
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          dropdownColor: AppColors.primaryLight,
          isExpanded: true,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white,
          ),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontFamily: AppTypography.family,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (v) => onChanged(v ?? value),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isStudent = userRole == "student";

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isStudent)
            _buildDropdownField(
              value: selectedGroup,
              items: const ["HSC", "SSC"],
              onChanged: onGroupChanged,
              hint: "Select Group",
            ),
          if (!isStudent)
            _buildDropdownField(
              value: selectedLevel,
              items: const ["Science", "Arts", "Commerce"],
              onChanged: onLevelChanged,
              hint: "Select Level",
            ),
          _buildDropdownField(
            value: selectedCourse,
            items: const ["Finance", "Math", "English", "ICT", "Biology"],
            onChanged: onCourseChanged,
            hint: "Select Course",
          ),
        ],
      ),
    );
  }
}
