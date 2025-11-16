import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class SupportFeedback extends StatelessWidget {
  final VoidCallback onFAQ;
  final VoidCallback onSupport;
  final VoidCallback onShare;

  const SupportFeedback({
    super.key,
    required this.onFAQ,
    required this.onSupport,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Support & Feedback",
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 14),
        _item(Icons.help_outline, "FAQ", "Frequently asked questions", onFAQ),
        const SizedBox(height: 10),
        _item(
          Icons.support_agent,
          "Contact Support",
          "Get in touch with our team",
          onSupport,
        ),
        const SizedBox(height: 10),
        _item(
          Icons.share_rounded,
          "Share App",
          "Tell your friends about QuizCrafter",
          onShare,
        ),
      ],
    );
  }

  Widget _item(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.secondaryDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 28, color: AppColors.primaryLight),
            ),

            const SizedBox(width: 14),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
