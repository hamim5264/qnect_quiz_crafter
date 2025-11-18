import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StudentProfileActionsSection extends StatelessWidget {
  final bool isGuest;

  final VoidCallback onEditProfile;
  final VoidCallback onCertificates;
  final VoidCallback onDeleteAccount;
  final VoidCallback onStudentFeedback;
  final VoidCallback onAdminFeedback;

  const StudentProfileActionsSection({
    super.key,
    required this.isGuest,
    required this.onEditProfile,
    required this.onCertificates,
    required this.onDeleteAccount,
    required this.onStudentFeedback,
    required this.onAdminFeedback,
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

        _frostedWrapper(
          disabled: isGuest,
          child: _actionItem(
            icon: Icons.edit,
            title: "Edit Profile",
            subtitle: "Update your name, photo, contact info",
            onTap: isGuest ? null : onEditProfile,
          ),
        ),

        const SizedBox(height: 10),

        _frostedWrapper(
          disabled: isGuest,
          child: _actionItem(
            icon: CupertinoIcons.rectangle_fill_on_rectangle_angled_fill,
            title: "Certificates",
            subtitle: "View your earned certificates",
            onTap: isGuest ? null : onCertificates,
          ),
        ),

        const SizedBox(height: 10),

        _frostedWrapper(
          disabled: isGuest,
          child: _actionItem(
            icon: CupertinoIcons.trash,
            title: "Delete Account",
            subtitle: "Clear all achievements & progress",
            onTap: isGuest ? null : onDeleteAccount,
          ),
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

        _frostedWrapper(
          disabled: isGuest,
          child: _actionItem(
            icon: CupertinoIcons.text_badge_checkmark,
            title: "Feedback & Ratings",
            subtitle: "See all reviews & ratings",
            onTap: isGuest ? null : onStudentFeedback,
          ),
        ),

        const SizedBox(height: 10),

        _frostedWrapper(
          disabled: isGuest,
          child: _actionItem(
            icon: CupertinoIcons.square_stack_3d_up_fill,
            title: "Guidelines",
            subtitle: "Read our guidelines",
            onTap: isGuest ? null : onAdminFeedback,
          ),
        ),

        const SizedBox(height: 10),

        _actionItem(
          icon: Icons.star,
          title: "Rate Us",
          subtitle: "Give us your feedback",
          onTap: onAdminFeedback,
        ),
      ],
    );
  }

  Widget _frostedWrapper({required bool disabled, required Widget child}) {
    if (!disabled) return child;

    return IgnorePointer(
      ignoring: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            child,

            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: onTap == null ? Colors.white24 : AppColors.secondaryDark,
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
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.black54,
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
