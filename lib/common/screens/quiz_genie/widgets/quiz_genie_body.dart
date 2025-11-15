import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../ui/design_system/tokens/typography.dart';
import '../controllers/quiz_genie_controller.dart';
import 'genie_header.dart';
import 'hint_section.dart';
import 'empty_state.dart';
import 'generated_quiz_view.dart';
import 'bottom_request_bar.dart';
import 'request_form_sheet.dart';

class QuizGenieBody extends ConsumerWidget {
  final String creatorRole;

  const QuizGenieBody({super.key, required this.creatorRole});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizGenieControllerProvider);
    final controller = ref.read(quizGenieControllerProvider.notifier);

    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const GenieHeader(),
                  const SizedBox(height: 26),
                  const HintSection(),
                  const SizedBox(height: 26),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child:
                    state.quiz == null
                        ? const EmptyState()
                        : GeneratedQuizView(role: creatorRole),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),

        if (state.status == QuizGenieStatus.generating ||
            state.status == QuizGenieStatus.saving)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.black.withValues(alpha: 0.35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Lottie.asset(
                        'assets/animations/chatbot.json',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.4, end: 1.0),
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Text(
                            "Generating your quiz...",
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              color: Colors.white.withValues(alpha: value),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                      onEnd: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: BottomRequestBar(
            onTap: () {
              controller.openForm();
              showRequestForm(context);
            },
          ),
        ),
      ],
    );
  }
}
