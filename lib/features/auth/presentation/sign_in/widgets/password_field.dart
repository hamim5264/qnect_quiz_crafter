import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/widgets/input_styles.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../controller/sign_in_controller.dart';

class PasswordField extends ConsumerWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInControllerProvider);
    final c = ref.read(signInControllerProvider.notifier);

    return TextFormField(
      obscureText: state.obscure,
      cursorColor: AppColors.secondaryDark,
      textInputAction: TextInputAction.done,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: AppTypography.family,
        fontSize: 16,
      ),
      decoration: pillInput(
        label: 'Password',
        hint: '••••••••••',
        suffix: IconButton(
          onPressed: c.toggleObscure,
          icon: Icon(
            state.obscure ? Icons.key_off_rounded : Icons.key_rounded,
            color: Colors.white70,
          ),
        ),
      ),
      onChanged: c.setPassword,
      validator: (v) => (v == null || v.isEmpty) ? 'Password required' : null,
    );
  }
}
