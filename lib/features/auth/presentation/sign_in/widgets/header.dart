import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class SignInHeader extends StatelessWidget {
  final String assetPath;

  const SignInHeader({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
        const SizedBox(height: 8),
        const Text(
          "Let’s get you\nsigned in!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Login to access your account",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 15,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
