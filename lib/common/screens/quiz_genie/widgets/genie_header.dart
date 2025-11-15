import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class GenieHeader extends StatelessWidget {
  const GenieHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          width: 160,
          child: Lottie.asset(
            'assets/animations/chatbot.json',
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Welcome to QuizGenie",
          style: TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Your Personal Quiz Generator Assistant",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
