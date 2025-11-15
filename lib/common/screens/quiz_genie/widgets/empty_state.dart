import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "Your draft will appear here!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
