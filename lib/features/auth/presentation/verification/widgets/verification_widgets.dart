import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/widgets/app_toast.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../controller/verification_controller.dart';

class SmsIconCircle extends StatelessWidget {
  const SmsIconCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.secondaryLight,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: AppColors.secondaryDark,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.chat_bubble_text,
                color: AppColors.textPrimary,
                size: 40,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class VerificationHeaderText extends ConsumerWidget {
  const VerificationHeaderText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verificationControllerProvider);

    return Column(
      children: [
        const Text(
          'Verify Email',
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontWeight: FontWeight.w900,
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "A 4-digit code has been sent to\n${state.maskedEmail}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class OtpInputFields extends ConsumerStatefulWidget {
  const OtpInputFields({super.key});

  @override
  ConsumerState<OtpInputFields> createState() => _OtpInputFieldsState();
}

class _OtpInputFieldsState extends ConsumerState<OtpInputFields> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final f in _focusNodes) {
      f.dispose();
    }
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int i) {
    if (value.isNotEmpty && i < 3) {
      _focusNodes[i + 1].requestFocus();
    }
    if (value.isEmpty && i > 0) {
      _focusNodes[i - 1].requestFocus();
    }

    final otp = _controllers.map((c) => c.text).join();
    ref.read(verificationControllerProvider.notifier).updateCode(otp);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (i) {
        return SizedBox(
          width: 50,
          height: 50,
          child: TextField(
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            cursorColor: AppColors.secondaryDark,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            onChanged: (v) => _onChanged(v, i),
            decoration: InputDecoration(
              filled: false,
              fillColor: Colors.transparent,
              counterText: "",
              contentPadding: const EdgeInsets.only(bottom: 4),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: AppColors.secondaryDark,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: AppColors.secondaryLight,
                  width: 2,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class ResendCodeText extends ConsumerWidget {
  const ResendCodeText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verificationControllerProvider);
    final controller = ref.read(verificationControllerProvider.notifier);

    return Column(
      children: [
        TextButton(
          onPressed:
              state.canResend
                  ? () async {
                    final sent = await controller.resendOtp();
                    if (sent) {
                      AppToast.showSuccess(context, "OTP resent");
                    } else {
                      AppToast.showError(context, "Failed to resend OTP");
                    }
                  }
                  : null,
          child: Text(
            'Resend Code',
            style: TextStyle(
              color: state.canResend ? Colors.white : Colors.white38,
              fontSize: 14,
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'This code will expire in ${state.secondsRemaining}s',
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 13,
            fontFamily: AppTypography.family,
          ),
        ),
      ],
    );
  }
}
