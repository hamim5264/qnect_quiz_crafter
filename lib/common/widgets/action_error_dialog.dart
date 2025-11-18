import 'package:flutter/material.dart';

import '../../ui/design_system/tokens/typography.dart';

class ActionErrorDialog extends StatelessWidget {
  final String title;
  final String message;

  const ActionErrorDialog({
    super.key,
    this.title = "Error",
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.redAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.white, size: 64),
            const SizedBox(height: 16),

            Text(
              title,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
              ),
              child: const Text(
                "Close",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
