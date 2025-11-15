import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';

class StepperDots extends StatelessWidget {
  final int step;

  const StepperDots({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final active = i == step;
        return Container(
          margin: const EdgeInsets.only(right: 10),
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.secondaryDark),
          ),
          child: Text(
            "${i + 1}",
            style: TextStyle(
              color: active ? Colors.black : Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}
