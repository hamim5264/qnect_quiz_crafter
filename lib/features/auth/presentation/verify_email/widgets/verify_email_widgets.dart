import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/input_styles.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../controller/verify_email_controller.dart';

class VerifyEmailImage extends StatelessWidget {
  const VerifyEmailImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/auth/verify_mail.png', height: 160);
  }
}

class VerifyEmailHeader extends StatelessWidget {
  const VerifyEmailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Verify Email',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontFamily: AppTypography.family,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Please enter your valid email address to reset your password',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontFamily: AppTypography.family,
          ),
        ),
      ],
    );
  }
}

class VerifyEmailInputField extends ConsumerWidget {
  const VerifyEmailInputField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(verifyEmailControllerProvider.notifier);
    return TextFormField(
      cursorColor: AppColors.secondaryDark,
      onChanged: controller.updateEmail,
      style: const TextStyle(color: Colors.white),
      decoration: pillInput(
        label: 'Email',
        hint: 'Enter your app verified email',
      ),
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
    );
  }
}

class VerifyEmailContinueButton extends ConsumerWidget {
  const VerifyEmailContinueButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verifyEmailControllerProvider);
    final controller = ref.read(verifyEmailControllerProvider.notifier);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            state.isLoading
                ? null
                : () async {
                  await controller.verifyEmail(context);
                },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryDark,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child:
            state.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                  'Continue',
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
      ),
    );
  }
}

class VerifyEmailSuccessMessage extends ConsumerWidget {
  const VerifyEmailSuccessMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verifyEmailControllerProvider);
    final controller = ref.read(verifyEmailControllerProvider.notifier);

    if (!state.linkSent) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 24),
        const Icon(Icons.check_circle, color: Colors.greenAccent, size: 60),
        const SizedBox(height: 12),
        const Text(
          "Password Reset Link Sent!",
          style: TextStyle(
            color: Colors.white,
            fontFamily: AppTypography.family,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Please check your email and reset your password.\nAfter resetting, return here and login again.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: AppTypography.family,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => controller.goToSignIn(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryDark,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class VerifyEmailHelpText extends StatelessWidget {
  const VerifyEmailHelpText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          "Don't remember your email?",
          style: TextStyle(
            fontSize: 13,
            fontFamily: AppTypography.family,
            color: Colors.white60,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            text: "Contact us at - ",
            style: const TextStyle(
              fontSize: 14,
              fontFamily: AppTypography.family,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            children: [
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    context.push('/need-help');
                  },
                  child: Text(
                    "Help",
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: AppTypography.family,
                      color: AppColors.secondaryDark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
