import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../presentation/teacher_status/controller/teacher_status_controller.dart';

class RejectedTeacherScreen extends ConsumerWidget {
  final String email;

  const RejectedTeacherScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(teacherStatusControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,

      appBar: CommonRoundedAppBar(
        title: "Account Rejected",
        onBack: () => context.go('/sign-in'),
      ),

      body:
          state.loading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Lottie.asset(
                        "assets/animations/rejected_animation.json",
                        repeat: true, // always play
                        animate: true,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      state.rejectionTitle ?? "Application Rejected",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        color: Colors.redAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      (state.rejectionMessage ??
                              "Dear {name}, your request was rejected.")
                          .replaceAll("{name}", state.name ?? "Teacher"),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (state.feedback.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Feedback from Admin:",
                              style: TextStyle(
                                fontFamily: AppTypography.family,
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...state.feedback.map(
                              (f) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "• ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Expanded(
                                      child: Text(
                                        f,
                                        style: const TextStyle(
                                          fontFamily: AppTypography.family,
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    _AttemptCircleProgress(count: state.attemptCount),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await ref
                              .read(teacherStatusControllerProvider.notifier)
                              .resendRequest(email);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Request sent again!",
                                style: TextStyle(
                                  fontFamily: AppTypography.family,
                                ),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryDark,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Send Request Again",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: AppTypography.family,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          context.push('/need-help');
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Contact Support",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppTypography.family,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

class _AttemptCircleProgress extends StatelessWidget {
  final int count;

  const _AttemptCircleProgress({required this.count});

  @override
  Widget build(BuildContext context) {
    List<bool> filled = [count >= 1, count >= 2, count >= 3];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: filled[i] ? AppColors.secondaryDark : Colors.white70,
              width: 2,
            ),
            color: filled[i] ? AppColors.secondaryDark : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(
            filled[i] ? "✕" : "${i + 1}",
            style: TextStyle(
              fontFamily: AppTypography.family,
              color: filled[i] ? Colors.black : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        );
      }),
    );
  }
}
