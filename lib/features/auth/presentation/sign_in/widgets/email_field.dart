import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/widgets/input_styles.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../controller/sign_in_controller.dart';

class EmailField extends ConsumerWidget {
  const EmailField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(signInControllerProvider.notifier);
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      cursorColor: AppColors.secondaryDark,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: AppTypography.family,
        fontSize: 16,
      ),
      decoration: pillInput(label: 'Email', hint: 'Enter your email address'),
      onChanged: c.setEmail,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Email required';
        final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim());
        return ok ? null : 'Enter a valid email';
      },
    );
  }
}
