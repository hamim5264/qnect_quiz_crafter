import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class ProfileActionsSection extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onCertificates;
  final VoidCallback onDeleteAccount;
  final VoidCallback onStudentFeedback;
  final VoidCallback onAdminFeedback;
  final VoidCallback onTeacherAddRating;

  const ProfileActionsSection({
    super.key,
    required this.onEditProfile,
    required this.onCertificates,
    required this.onDeleteAccount,
    required this.onStudentFeedback,
    required this.onAdminFeedback,
    required this.onTeacherAddRating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Profile Actions",
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 14),

        _actionItem(
          icon: Icons.edit,
          title: "Edit Profile",
          subtitle: "Update your name, photo, contact info",
          onTap: onEditProfile,
        ),

        const SizedBox(height: 10),

        _actionItem(
          icon: CupertinoIcons.rectangle_fill_on_rectangle_angled_fill,
          title: "Certificates",
          subtitle: "View your earned certificates",
          onTap: onCertificates,
        ),

        const SizedBox(height: 10),

        _actionItem(
          icon: CupertinoIcons.trash,
          title: "Delete Account",
          subtitle: "Clear all achievements & progress",
          onTap: onDeleteAccount,
        ),

        const SizedBox(height: 20),

        const Text(
          "Support & Feedback",
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 14),

        _actionItem(
          icon: Icons.people,
          title: "Students Feedback",
          subtitle: "See students review about you",
          onTap: onStudentFeedback,
        ),

        const SizedBox(height: 10),

        _actionItem(
          icon: Icons.message_rounded,
          title: "Admin Feedback",
          subtitle: "See your rejection feedback",
          onTap: onAdminFeedback,
        ),

        const SizedBox(height: 10),

        _actionItem(
          icon: Icons.star,
          title: "Rate Us",
          subtitle: "Give us your feedback",
          onTap: onTeacherAddRating,
        ),
      ],
    );
  }

  Widget _actionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
