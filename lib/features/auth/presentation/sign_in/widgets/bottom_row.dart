import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../ui/design_system/tokens/typography.dart';

class BottomRow extends StatelessWidget {
  const BottomRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => context.pushNamed('signUp'),
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
            ),
            child: const Text(
              "Don't have an account?  Sign Up",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            GoRouter.of(context).push('/guidelines');
          },
          child: const Text(
            'Terms & Conditions',
            style: TextStyle(
              color: Colors.white70,
              fontFamily: AppTypography.family,
              fontSize: 14,
              decoration: TextDecoration.underline,
              decorationThickness: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
