import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class CertificateInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? value;
  final VoidCallback? onTap;

  const CertificateInputField({
    super.key,
    required this.label,
    required this.icon,
    this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.secondaryDark, width: 1.3),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value ?? label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontFamily: AppTypography.family,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(icon, color: Colors.white54, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
