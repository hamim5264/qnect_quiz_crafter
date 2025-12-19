import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class GuestQuizWarningScreen extends StatelessWidget {
  const GuestQuizWarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const SizedBox(height: 18),

              Image.asset(
                'assets/icons/warning.png',
                height: 120,
                width: 120,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 18),

              const Text(
                "Warning",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: const Text(
                  "• Screenshots / Screen recording are not allowed during the quiz.\n"
                  "• This is a guest quiz — your attempt will NOT be saved.\n\n"
                  "Login or Create an account to unlock all premium features (saving attempts, XP, leaderboard, certificates).",
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed('guestQuizAttempt');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "I Understand, Start Quiz",
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => context.pop(),
                child: const Text(
                  "Go Back",
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white70,
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
