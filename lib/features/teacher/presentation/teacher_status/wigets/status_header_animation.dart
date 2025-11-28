import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StatusHeaderAnimation extends StatelessWidget {
  final String status;

  const StatusHeaderAnimation({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final String asset =
        status == "rejected"
            ? 'assets/animations/rejected_animation.json'
            : 'assets/animations/main_animation.json';

    return Container(
      width: 160,
      height: 160,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Lottie.asset(asset, fit: BoxFit.contain, repeat: true),
        ),
      ),
    );
  }
}
