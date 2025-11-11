import 'package:flutter/material.dart';

import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class SurpriseQuizImportButton extends StatelessWidget {
  const SurpriseQuizImportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                backgroundColor: AppColors.primaryLight,
                title: const Text(
                  'Import from QC Vault',
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                content: const Text(
                  'This feature will let you pick saved questions from the QC Vault. (Demo state)',
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white70,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
        );
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.secondaryDark, width: 1.4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: const Text(
        'Import from QC Vault',
        style: TextStyle(
          fontFamily: AppTypography.family,
          color: AppColors.secondaryDark,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
