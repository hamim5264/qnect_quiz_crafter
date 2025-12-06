import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class LeaderboardFilterCard extends StatelessWidget {
  final String userRole;
  final String selectedGroup;
  final String selectedLevel;
  final String selectedCourse;
  final List<Map<String, dynamic>> availableCourses;

  final ValueChanged<String> onGroupChanged;
  final ValueChanged<String> onLevelChanged;
  final ValueChanged<String> onCourseChanged;

  const LeaderboardFilterCard({
    super.key,
    required this.userRole,
    required this.selectedGroup,
    required this.selectedLevel,
    required this.selectedCourse,
    required this.availableCourses,
    required this.onGroupChanged,
    required this.onLevelChanged,
    required this.onCourseChanged,
  });

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String> onChanged,
    required String hint,
  }) {
    final String? dropdownValue =
        (value != null && value.isNotEmpty && items.contains(value))
            ? value
            : null;

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
          value: dropdownValue,
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
          onChanged: (v) {
            if (v == null) return;
            onChanged(v);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isStudent = userRole == "student";

    String? selectedCourseTitle;
    if (selectedCourse.isNotEmpty && availableCourses.isNotEmpty) {
      final match = availableCourses.firstWhere(
        (e) => e["id"].toString() == selectedCourse,
        orElse: () => <String, dynamic>{},
      );
      if (match.isNotEmpty) {
        selectedCourseTitle = match["title"]?.toString();
      }
    }

    final List<String> courseTitles =
        availableCourses
            .map((e) => e["title"]?.toString() ?? "Unknown Course")
            .toList();

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
            _buildDropdown(
              value: selectedGroup,
              items: const ["Science", "Arts", "Commerce"],
              onChanged: onGroupChanged,
              hint: "Select Group",
            ),

          if (!isStudent)
            _buildDropdown(
              value: selectedLevel,
              items: const ["HSC", "SSC"],
              onChanged: onLevelChanged,
              hint: "Select Level",
            ),

          _buildDropdown(
            value: selectedCourseTitle,
            items: courseTitles,
            onChanged: (title) {
              final match = availableCourses.firstWhere(
                (e) => (e["title"]?.toString() ?? "") == title,
                orElse: () => <String, dynamic>{},
              );
              if (match.isNotEmpty) {
                onCourseChanged(match["id"].toString());
              }
            },
            hint: "Select Course",
          ),
        ],
      ),
    );
  }
}
