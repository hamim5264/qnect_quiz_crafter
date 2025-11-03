import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../../../../../ui/design_system/tokens/colors.dart';

class ManageUserHeader extends StatelessWidget {
  const ManageUserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              LucideIcons.arrowLeft,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        const Text(
          "Manage Users",
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
