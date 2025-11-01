import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/app_loader.dart';
import '../../../../common/widgets/app_toast.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import 'controller/verification_controller.dart';
import 'widgets/verification_widgets.dart';

class VerifyOtpScreen extends ConsumerWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(verificationControllerProvider.notifier);
    final state = ref.watch(verificationControllerProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initEmailVerification(email);
    });

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        AppToast.showError(context, "You can't go back from here");
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SmsIconCircle(),
                const SizedBox(height: 10),

                const VerificationHeaderText(),
                const SizedBox(height: 30),

                const OtpInputFields(),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child:
                      state.isVerifying
                          ? const AppLoader(size: 40)
                          : ElevatedButton(
                            onPressed: () async {
                              final ok = await controller.verifyOtp();
                              if (ok && context.mounted) {
                                context.go('/set-password');
                              } else {
                                AppToast.showError(
                                  context,
                                  "Invalid or expired OTP",
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryDark,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Verify',
                              style: TextStyle(
                                fontFamily: AppTypography.family,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                ),
                const SizedBox(height: 8),

                const ResendCodeText(),

                SizedBox(height: bottomInset > 0 ? 200 : 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
