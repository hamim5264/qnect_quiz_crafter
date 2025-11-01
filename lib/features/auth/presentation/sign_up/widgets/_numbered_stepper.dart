import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../controller/sign_up_controller.dart';

class NumberedStepper extends ConsumerWidget {
  final int currentIndex;

  const NumberedStepper({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpControllerProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final isDone = i < state.step;
        final isActive = i == state.step;
        return Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color:
                    isDone
                        ? AppColors.secondaryDark
                        : isActive
                        ? Colors.white
                        : Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Center(
                child:
                    isDone
                        ? const Icon(
                          Icons.check,
                          size: 18,
                          color: AppColors.textPrimary,
                        )
                        : Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: AppTypography.family,
                            color: isActive ? Colors.black : Colors.white,
                          ),
                        ),
              ),
            ),
            if (i < 3)
              Container(
                width: 30,
                height: 2,
                color:
                    i < state.step ? AppColors.secondaryDark : Colors.white24,
              ),
          ],
        );
      }),
    );
  }
}
