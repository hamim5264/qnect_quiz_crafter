import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../ui/design_system/tokens/colors.dart';

class AppLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLoader({super.key, this.size = 60, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.dotsTriangle(
        color: color ?? AppColors.secondaryDark,
        size: size,
      ),
    );
  }
}
