import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';

class OnboardPage1 extends StatelessWidget {
  const OnboardPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * 0.36,
            child: Image.asset(
              'assets/images/onboarding/welcome_illustration.png',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'WELCOME',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Aboreto',
              fontSize: 48,
              height: 1.1,
              letterSpacing: 2.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),
          const Text(
            'LEARN.  TEACH.  LEVEL UP.',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Aboreto',
              fontSize: 15,
              letterSpacing: 1.6,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 28),
          const _GrowthStat(),

          const SizedBox(height: 28),

          const Center(
            child: Text(
              'QUIZCRAFTER',
              style: TextStyle(
                fontFamily: 'Aboreto',
                fontSize: 28,
                letterSpacing: 1.6,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Center(
            child: Text(
              'QuizCrafter brings students and teachers\n'
              'together for fast, fair, and fun learning',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BarlowCondensed',
                fontSize: 16,
                height: 1.3,
                color: Colors.white70,
              ),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _GrowthStat extends StatelessWidget {
  const _GrowthStat();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          height: 68,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(left: 0, right: 44, top: 10, child: _bar()),
              Positioned(
                left: 0,
                right: 58,
                top: 26,
                child: _bar(widthFactor: 0.72),
              ),
              Positioned(
                left: 0,
                right: 70,
                top: 42,
                child: _bar(widthFactor: 0.54),
              ),
            ],
          ),
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '8.5 K',
              style: TextStyle(
                fontFamily: 'Aboreto',
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              'Members',
              style: TextStyle(
                fontFamily: 'Aboreto',
                fontSize: 14,
                color: Colors.white70,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bar({double widthFactor = 1}) => FractionallySizedBox(
    widthFactor: widthFactor,
    alignment: Alignment.centerLeft,
    child: Container(
      height: 9,
      decoration: BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  );
}
