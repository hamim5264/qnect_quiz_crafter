import 'package:flutter/material.dart';

class OnboardPage2 extends StatelessWidget {
  const OnboardPage2({super.key});

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
              'assets/images/onboarding/smarter_quizzes.png',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'SMARTER\nQUIZZES',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Aboreto',
                fontSize: 48,
                height: 1.1,
                letterSpacing: 2.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'BUILD & PRACTICE — SMARTER',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Aboreto',
                fontSize: 15,
                letterSpacing: 1.6,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Bullet(text: 'QuizGenie (AI)'),
              _Bullet(text: 'Question Bank'),
              _Bullet(text: 'Demo Quiz'),
            ],
          ),

          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Draft with QuizGenie or pick from the QuizCrafter Question Bank;\n'
              'learners get clear solutions and timing',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BarlowCondensed',
                fontSize: 16,
                height: 1.3,
                color: Colors.white70,
              ),
            ),
          ),
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
