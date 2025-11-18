import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';

import 'profile_image_picker.dart';
import '../../../../common/widgets/app_skeleton.dart';
import 'level_badge_skeleton.dart';

class ProfileHeaderSection extends StatelessWidget {
  final String role;

  final String? name;
  final String? email;
  final String? profileImage;

  final bool isLoading;

  final Function(File?) onImageSelected;

  const ProfileHeaderSection({
    super.key,
    required this.role,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.isLoading,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTeacher = role == "teacher";
    final bool isStudent = role == "student";
    final bool isAdmin = role == "admin";

    return Column(
      children: [
        ProfileImagePicker(
          imageUrl: profileImage,
          isLoading: isLoading,
          onImageSelected: onImageSelected,
        ),

        const SizedBox(height: 12),

        isLoading
            ? const AppSkeleton(width: 120, height: 16)
            : Text(
              (name ?? "User").toUpperCase(),
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),

        const SizedBox(height: 4),

        isLoading
            ? const AppSkeleton(width: 150, height: 14)
            : Text(
              email ?? "email@example.com",
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white70,
                fontSize: 13,
              ),
            ),

        const SizedBox(height: 10),

        if (isTeacher || isStudent)
          isLoading
              ? const LevelBadgeSkeleton()
              : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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
                    Icon(
                      Icons.star_rounded,
                      color: Colors.orangeAccent,
                      size: 18,
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
