import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import 'widgets/onboard_page1.dart';
import 'widgets/onboard_page2.dart';
import 'widgets/onboard_page3.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: const [
                  OnboardPage1(),
                  OnboardPage2(),
                  OnboardPage3(),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Dots(index: _index, count: 3),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Row(
                children: [
                  if (_index < 2)
                    TextButton(
                      onPressed:
                          () => _controller.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 68),

                  const Spacer(),

                  FilledButton(
                    onPressed: () {
                      if (_index < 2) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        );
                      } else {
                        context.go('/sign-in');
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.secondaryDark,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      _index < 2 ? 'Next' : 'Start',
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int index;
  final int count;

  const _Dots({required this.index, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: active ? 28 : 10,
          decoration: BoxDecoration(
            color: active ? AppColors.secondaryDark : Colors.white30,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
