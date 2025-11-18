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
        color: Colors.white12,
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
              color: AppColors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You're signed in as Admin",
            style: TextStyle(
              fontFamily: AppTypography.family,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatusButton(
                label: 'Create Account',
                enabled: !isLoggedIn,
                onTap: () {
                  // go to sign up
                },
              ),
              const SizedBox(width: 10),
              _StatusButton(
                label: 'Sign In',
                enabled: !isLoggedIn,
                onTap: () {
                  // go to sign in
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
  final bool enabled;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Opacity(
        opacity: enabled ? 1 : 0.4, // glass effect
        child: IgnorePointer(
          ignoring: !enabled, // disable tap
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: enabled
                  ? AppColors.primaryLight
                  : Colors.white.withOpacity(0.30), // glassy background
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: enabled ? Colors.transparent : Colors.white30,
                width: 1.2,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: enabled
                      ? AppColors.textPrimary
                      : Colors.white70, // glassy text
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

