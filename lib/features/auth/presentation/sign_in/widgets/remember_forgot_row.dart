import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../controller/sign_in_controller.dart';

class RememberForgotRow extends ConsumerWidget {
  const RememberForgotRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInControllerProvider);
    final c = ref.read(signInControllerProvider.notifier);
    return Row(
      children: [
        Checkbox(
          value: state.remember,
          onChanged: (v) => c.setRemember(v ?? false),
          side: BorderSide(color: AppColors.secondaryDark),
          checkColor: AppColors.primaryDark,
          activeColor: AppColors.secondaryDark,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const Text(
          'Remember me',
          style: TextStyle(
            color: Colors.white70,
            fontFamily: AppTypography.family,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => context.push('/verify-email'),
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              color: Colors.white70,
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
