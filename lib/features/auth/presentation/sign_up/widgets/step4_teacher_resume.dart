import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/widgets/input_styles.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../controller/sign_up_controller.dart';

class Step4TeacherResume extends ConsumerWidget {
  const Step4TeacherResume({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(signUpControllerProvider.notifier);

    return TextFormField(
      cursorColor: AppColors.secondaryDark,
      textInputAction: TextInputAction.done,
      decoration: pillInput(
        label: 'Resume Link',
        hint: 'Enter your resume link',
      ),
      style: const TextStyle(
        color: Colors.white,
        fontFamily: AppTypography.family,
        fontSize: 14,
      ),
      onChanged: c.setResume,
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
    );
  }
}
