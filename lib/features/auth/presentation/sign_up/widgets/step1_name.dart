import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnect_quiz_crafter/ui/design_system/tokens/colors.dart';
import '../../../../../common/widgets/input_styles.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../controller/sign_up_controller.dart';

class Step1Name extends ConsumerWidget {
  const Step1Name({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(signUpControllerProvider.notifier);

    return Column(
      children: [
        TextFormField(
          cursorColor: AppColors.secondaryDark,
          textInputAction: TextInputAction.next,
          decoration: pillInput(
            label: 'First Name',
            hint: 'Enter your first name',
          ),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: AppTypography.family,
            fontSize: 14,
          ),
          onChanged: c.setFirstName,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          cursorColor: AppColors.secondaryDark,
          textInputAction: TextInputAction.done,
          decoration: pillInput(
            label: 'Last Name',
            hint: 'Enter your last name',
          ),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: AppTypography.family,
            fontSize: 14,
          ),
          onChanged: c.setLastName,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
      ],
    );
  }
}
