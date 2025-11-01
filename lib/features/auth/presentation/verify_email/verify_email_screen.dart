import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/app_loader.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import 'widgets/verify_email_widgets.dart';
import 'controller/verify_email_controller.dart';

class VerifyEmailScreen extends ConsumerWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verifyEmailControllerProvider);
    final controller = ref.read(verifyEmailControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const VerifyEmailImage(),
              const SizedBox(height: 24),

              const Text(
                'Forgot Password ?',
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                'Please enter your verified email\nwe will send a reset link.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              if (!state.linkSent) ...[
                const VerifyEmailInputField(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        state.isLoading
                            ? null
                            : () => controller.verifyEmail(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child:
                        state.isLoading
                            ? const AppLoader(size: 32, color: Colors.white)
                            : const Text(
                              'Continue',
                              style: TextStyle(
                                fontFamily: AppTypography.family,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 24),
                const VerifyEmailHelpText(),
              ],

              if (state.linkSent) ...[
                const SizedBox(height: 30),
                const Icon(
                  Icons.check_circle,
                  color: Colors.greenAccent,
                  size: 70,
                ),
                const SizedBox(height: 20),
                Text(
                  'Reset Link Sent!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTypography.family,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Check your email and reset your password.\n'
                  'After resetting, return to sign in.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: AppTypography.family,
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () => controller.goToSignIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryDark,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
