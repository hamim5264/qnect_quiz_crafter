import 'package:flutter/material.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import 'profile_image_picker.dart';

class ProfileHeaderSection extends StatelessWidget {
  final String role;

  const ProfileHeaderSection({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final bool isTeacher = role == "teacher";
    final bool isStudent = role == "student";

    return Column(
      children: [
        const ProfileImagePicker(),
        const SizedBox(height: 12),

        const Text(
          "Hasna Hena",
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const Text(
          "hena.cse@diu.edu.bd",
          style: TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white70,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 10),

        if (isTeacher || isStudent)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondaryDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Level 04 ",
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                Icon(Icons.star_rounded, color: Colors.orangeAccent, size: 18),
              ],
            ),
          ),
      ],
    );
  }
}
