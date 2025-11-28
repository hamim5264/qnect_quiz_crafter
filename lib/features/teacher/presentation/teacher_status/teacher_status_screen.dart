import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/features/teacher/presentation/teacher_status/wigets/attempt_counter.dart';
import 'package:qnect_quiz_crafter/features/teacher/presentation/teacher_status/wigets/rejection_section.dart';
import 'package:qnect_quiz_crafter/features/teacher/presentation/teacher_status/wigets/status_action_buttons.dart';
import 'package:qnect_quiz_crafter/features/teacher/presentation/teacher_status/wigets/status_header_animation.dart';
import 'package:qnect_quiz_crafter/features/teacher/presentation/teacher_status/wigets/status_timeline.dart';

import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';

import 'controller/teacher_status_controller.dart';

class TeacherStatusScreen extends ConsumerStatefulWidget {
  final String email;

  const TeacherStatusScreen({super.key, required this.email});

  @override
  ConsumerState<TeacherStatusScreen> createState() =>
      _TeacherStatusScreenState();
}

class _TeacherStatusScreenState extends ConsumerState<TeacherStatusScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(teacherStatusControllerProvider.notifier)
          .loadStatusByEmail(widget.email);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teacherStatusControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,

      appBar: CommonRoundedAppBar(
        title: "Teacher Account Status",
        onBack: () {
          context.go('/sign-in');
        },
      ),

      body:
          state.loading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StatusHeaderAnimation(status: state.status),
                    const SizedBox(height: 16),

                    Text(
                      state.name ?? "Unknown Teacher",
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      state.email ?? widget.email,
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (state.status == "rejected")
                      RejectionSection(state: state)
                    else if (state.status == "not_found")
                      const Text(
                        "No teacher account found with this email.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          color: Colors.white70,
                        ),
                      )
                    else
                      StatusTimeline(status: state.status),

                    const SizedBox(height: 16),

                    AttemptProgressBar(attemptCount: state.attemptCount),

                    const Spacer(),

                    StatusActionButtons(
                      email: state.email ?? widget.email,
                      status: state.status,
                    ),
                  ],
                ),
              ),
    );
  }
}
