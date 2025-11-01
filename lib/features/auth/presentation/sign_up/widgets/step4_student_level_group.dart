import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnect_quiz_crafter/ui/design_system/tokens/colors.dart';
import '../../../../../common/widgets/input_styles.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../controller/sign_up_controller.dart';

class Step4StudentLevelGroup extends ConsumerWidget {
  const Step4StudentLevelGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(signUpControllerProvider.notifier);
    final state = ref.watch(signUpControllerProvider);

    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: state.level.isEmpty ? null : state.level,
          decoration: pillInput(label: 'Level', hint: 'HSC'),
          dropdownColor: AppColors.primaryLight,
          iconEnabledColor: Colors.white70,
          isExpanded: true,
          isDense: true,
          borderRadius: BorderRadius.circular(30),
          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 14,
            color: Colors.white70,
          ),
          items: const [
            DropdownMenuItem(value: 'SSC', child: Text('SSC')),
            DropdownMenuItem(value: 'HSC', child: Text('HSC')),
            DropdownMenuItem(
              value: 'Undergraduate',
              child: Text('Undergraduate'),
            ),
          ],

          selectedItemBuilder: (context) {
            return const [
              Text('SSC', style: TextStyle(color: Colors.white70)),
              Text('HSC', style: TextStyle(color: Colors.white70)),
              Text('Undergraduate', style: TextStyle(color: Colors.white70)),
            ];
          },

          onChanged: (v) => c.setLevel(v ?? ''),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: state.group.isEmpty ? null : state.group,

          decoration: pillInput(label: 'Group', hint: 'Science').copyWith(
            hintStyle: const TextStyle(
              color: Colors.white70,
              fontFamily: AppTypography.family,
              fontSize: 14,
            ),
            labelStyle: const TextStyle(
              color: Colors.white70,
              fontFamily: AppTypography.family,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          dropdownColor: AppColors.primaryLight,
          iconEnabledColor: Colors.white70,
          isExpanded: true,
          isDense: true,
          borderRadius: BorderRadius.circular(30),

          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 14,
            color: Colors.white70,
          ),

          items: const [
            DropdownMenuItem(value: 'Science', child: Text('Science')),
            DropdownMenuItem(value: 'Commerce', child: Text('Commerce')),
            DropdownMenuItem(value: 'Arts', child: Text('Arts')),
          ],

          selectedItemBuilder: (context) {
            return const [
              Text('Science', style: TextStyle(color: Colors.white70)),
              Text('Commerce', style: TextStyle(color: Colors.white70)),
              Text('Arts', style: TextStyle(color: Colors.white70)),
            ];
          },

          onChanged: (v) => c.setGroup(v ?? ''),
        ),
      ],
    );
  }
}
