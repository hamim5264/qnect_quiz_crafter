import 'package:flutter/material.dart';

import '../../../../../ui/design_system/tokens/typography.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 24),
        Text(
          'Get Started Now',
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontWeight: FontWeight.w900,
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Create an account to explore our app',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
