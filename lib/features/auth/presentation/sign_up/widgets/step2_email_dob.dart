import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../common/widgets/input_styles.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../controller/sign_up_controller.dart';

class Step2EmailDob extends ConsumerWidget {
  const Step2EmailDob({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(signUpControllerProvider.notifier);
    final state = ref.watch(signUpControllerProvider);

    return Column(
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          cursorColor: AppColors.secondaryDark,
          decoration: pillInput(
            label: 'Email',
            hint: 'Enter your valid email address',
          ),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: AppTypography.family,
            fontSize: 14,
          ),
          onChanged: c.setEmail,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Required';
            final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim());
            return ok ? null : 'Enter a valid email';
          },
        ),

        const SizedBox(height: 14),

        TextFormField(
          cursorColor: AppColors.secondaryDark,
          textInputAction: TextInputAction.done,
          readOnly: true,
          controller: TextEditingController(
            text:
                state.dob != null
                    ? DateFormat('dd/MM/yyyy').format(state.dob!)
                    : '',
          ),
          decoration: pillInput(
            label: 'Date of Birth',
            hint: 'DD/MM/YYYY',
            suffix: const Icon(Icons.calendar_month, color: Colors.white70),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: AppTypography.family,
            fontSize: 14,
          ),
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime(1960),
              lastDate: DateTime(now.year - 5, now.month, now.day),
              initialDate: DateTime(now.year - 15),
              builder:
                  (ctx, child) => Theme(
                    data: Theme.of(ctx).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: AppColors.secondaryDark,
                        surface: AppColors.primaryLight,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.secondaryDark,
                        ),
                      ),
                      dialogTheme: const DialogTheme(
                        backgroundColor: AppColors.primaryDark,
                      ),
                    ),
                    child: child!,
                  ),
            );
            c.setDob(picked);
          },
        ),
      ],
    );
  }
}
