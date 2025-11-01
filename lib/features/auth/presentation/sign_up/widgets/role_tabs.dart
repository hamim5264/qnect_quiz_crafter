import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../controller/sign_up_controller.dart';
import '../controller/sign_up_state.dart';

class RoleTabs extends ConsumerWidget {
  const RoleTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpControllerProvider);
    final c = ref.read(signUpControllerProvider.notifier);

    Widget tab(SignUpRole r, String label) {
      final active = state.role == r;

      return Expanded(
        child: GestureDetector(
          onTap: () => c.setRole(r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: active ? AppColors.secondaryDark : Colors.white10,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: active ? AppColors.secondaryDark : Colors.white24,
                width: 2,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: active ? AppColors.textPrimary : Colors.white70,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab(SignUpRole.student, 'Student'),
        const SizedBox(width: 12),
        tab(SignUpRole.teacher, 'Teacher'),
      ],
    );
  }
}
