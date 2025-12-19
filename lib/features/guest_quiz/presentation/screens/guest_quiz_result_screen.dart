import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class GuestQuizResultScreen extends StatelessWidget {
  final int correct;
  final int total;
  final String reason;

  const GuestQuizResultScreen({
    super.key,
    required this.correct,
    required this.total,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0 : ((correct / total) * 100).round();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const SizedBox(height: 10),

              SizedBox(
                height: 220,
                width: 220,
                child: Lottie.asset('assets/trophy/gold.json'),
              ),

              const SizedBox(height: 14),

              const Text(
                "Quiz Result",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "$correct / $total Correct",
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$percent% Score",
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reason == "time_up"
                          ? "Time is up!"
                          : (reason == "manual_exit"
                              ? "You exited early."
                              : "Submitted successfully."),
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.goNamed('guestQuizWarning');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Try Again",
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
                  "Back",
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
