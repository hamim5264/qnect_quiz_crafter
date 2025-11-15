import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../controllers/quiz_genie_controller.dart';
import 'request_form_sheet.dart';

class HintChip extends ConsumerWidget {
  final String text;

  const HintChip({super.key, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(quizGenieControllerProvider.notifier);

    return GestureDetector(
      onTap: () {
        c.setTopic(text);
        c.openForm();
        showRequestForm(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ),
    );
  }
}
