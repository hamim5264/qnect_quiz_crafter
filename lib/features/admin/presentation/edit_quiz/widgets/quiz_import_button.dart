import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizImportButton extends StatelessWidget {
  const QuizImportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(
          CupertinoIcons.cloud_download,
          color: Colors.black,
          size: 18,
        ),
        label: const Text(
          'Import From QC Vault',
          style: TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryDark,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
