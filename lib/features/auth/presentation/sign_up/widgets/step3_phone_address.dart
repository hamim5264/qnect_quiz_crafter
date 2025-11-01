import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/widgets/input_styles.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../controller/sign_up_controller.dart';

class Step3PhoneAddress extends ConsumerWidget {
  const Step3PhoneAddress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(signUpControllerProvider.notifier);

    return Column(
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          cursorColor: AppColors.secondaryDark,
          decoration: pillInput(
            label: 'Mobile Number',
            hint: '+880 1**-******',
          ),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: AppTypography.family,
            fontSize: 14,
          ),
          onChanged: c.setPhone,
          validator:
              (v) =>
                  (v == null || v.trim().length < 6) ? 'Invalid number' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          cursorColor: AppColors.secondaryDark,
          textInputAction: TextInputAction.done,
          decoration: pillInput(label: 'Address', hint: 'Enter your address'),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: AppTypography.family,
            fontSize: 14,
          ),
          onChanged: c.setAddress,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
      ],
    );
  }
}
