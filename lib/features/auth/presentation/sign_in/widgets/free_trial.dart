import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class FreeTrial extends StatelessWidget {
  const FreeTrial({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.3),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.white.withValues(alpha: 0.1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      ),
      onPressed: () {
        context.go('/guest_and_student-home', extra: true);
      },
      child: const Text(
        "Try Free Trial",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          fontFamily: AppTypography.family,
        ),
      ),
    );
  }
}
