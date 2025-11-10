import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizBottomNav extends StatelessWidget {
  final bool isLast;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const QuizBottomNav({
    super.key,
    required this.isLast,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 120,
        decoration: const BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.white,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.back, color: Colors.black),
                  onPressed: onPrevious,
                ),
              ),

              Container(
                height: 48,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  isLast ? "Done" : "Next",
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),

              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.white,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.forward, color: Colors.black),
                  onPressed: onNext,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
