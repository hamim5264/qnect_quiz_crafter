import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnect_quiz_crafter/features/auth/presentation/sign_up/widgets/step1_name.dart';
import 'package:qnect_quiz_crafter/features/auth/presentation/sign_up/widgets/step2_email_dob.dart';
import 'package:qnect_quiz_crafter/features/auth/presentation/sign_up/widgets/step3_phone_address.dart';
import 'package:qnect_quiz_crafter/features/auth/presentation/sign_up/widgets/step4_student_level_group.dart';
import 'package:qnect_quiz_crafter/features/auth/presentation/sign_up/widgets/step4_teacher_resume.dart';

import '../../../../../common/widgets/app_loader.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../controller/sign_up_controller.dart';
import '../controller/sign_up_state.dart';

class FormBox extends ConsumerWidget {
  final PageController controller;

  const FormBox({required this.controller, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpControllerProvider);
    final c = ref.read(signUpControllerProvider.notifier);

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            border: Border.all(color: Colors.white24, width: 1.4),
            borderRadius: BorderRadius.circular(30),
          ),
          child:
              state.loading
                  ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: AppLoader(size: 50),
                  )
                  : Column(
                    children: [
                      SizedBox(
                        height: 120,
                        child: PageView(
                          controller: controller,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (i) => c.setStep(i),
                          children: [
                            const Step1Name(),
                            const Step2EmailDob(),
                            const Step3PhoneAddress(),
                            state.role == SignUpRole.student
                                ? const Step4StudentLevelGroup()
                                : const Step4TeacherResume(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (state.step < 3) {
                              controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              c.next();
                            } else {
                              c.submit(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryDark,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text(
                            state.step < 3 ? 'Next' : 'Submit',
                            style: const TextStyle(
                              fontFamily: AppTypography.family,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
