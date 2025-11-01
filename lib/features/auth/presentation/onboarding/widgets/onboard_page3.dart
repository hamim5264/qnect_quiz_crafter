import 'package:flutter/material.dart';

class OnboardPage3 extends StatelessWidget {
  const OnboardPage3({super.key});

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
              'assets/images/onboarding/progress_rewards.png',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'PROGRESS\n& REWARDS',
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
            'BADGES.  LEVELS.  CERTIFICATES.',
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Bullet(text: 'Track Growth'),
              _Bullet(text: 'Get Recognized'),
              _Bullet(text: 'Buy Courses Safely'),
            ],
          ),

          const SizedBox(height: 28),
          const Center(
            child: Text(
              'Earn XP, climb leaderboards, and unlock\n'
              'certificates as you progress.',
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

class _Bullet extends StatelessWidget {
  final String text;

  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '•',
            style: TextStyle(color: Colors.white, fontSize: 20, height: 1.2),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'BarlowCondensed',
              fontSize: 16,
              color: Colors.white,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
