import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../controller/teacher_status_controller.dart';

class StatusActionButtons extends ConsumerWidget {
  final String email;
  final String status;

  const StatusActionButtons({
    super.key,
    required this.email,
    required this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool canResend = status == "rejected";

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                canResend
                    ? () {
                      ref
                          .read(teacherStatusControllerProvider.notifier)
                          .resendRequest(email);
                    }
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  canResend ? AppColors.primaryLight : Colors.white10,
              disabledBackgroundColor: Colors.white10,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Send Request Again",
              style: TextStyle(
                fontFamily: AppTypography.family,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: canResend ? Colors.black : Colors.white38,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              if (context.mounted) {
                context.push('/need-help');
              }
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white30),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Contact Support",
              style: TextStyle(
                fontFamily: AppTypography.family,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
