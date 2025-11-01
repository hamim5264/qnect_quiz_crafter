import 'package:flutter/material.dart';

import '../../../../../ui/design_system/tokens/colors.dart';

class ProgressDots extends StatelessWidget {
  final int index;

  const ProgressDots({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: active ? 28 : 10,
          decoration: BoxDecoration(
            color: active ? AppColors.secondaryDark : Colors.white30,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}
