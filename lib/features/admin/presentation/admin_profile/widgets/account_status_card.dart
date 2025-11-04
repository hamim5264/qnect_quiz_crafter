import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class AccountStatusCard extends StatelessWidget {
  final bool isLoggedIn;

  const AccountStatusCard({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryLight,
            radius: 26,
            child: const FaIcon(
              FontAwesomeIcons.userShield,
              color: AppColors.secondaryDark,
              size: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You're signed in as Admin",
            style: TextStyle(
              fontFamily: AppTypography.family,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatusButton(
                label: 'Create Account',
                color: AppColors.secondaryDark,
                textColor: AppColors.textPrimary,
                onTap: () {
                  // navigate to sign up screen
                },
              ),
              const SizedBox(width: 10),
              _StatusButton(
                label: 'Sign In',
                color:
                    isLoggedIn
                        ? AppColors.secondaryDark
                        : AppColors.primaryLight,
                textColor: AppColors.textPrimary,
                onTap: () {
                  // navigate to sign in screen
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
