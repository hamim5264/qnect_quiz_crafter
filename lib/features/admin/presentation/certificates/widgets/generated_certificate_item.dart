import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import 'certificate_card.dart';

class GeneratedCertificateItem extends StatelessWidget {
  final String role;
  final String certName;
  final String userName;
  final String issueDate;
  final bool isSent;
  final VoidCallback onSend;
  final VoidCallback onDeleteRequest;

  const GeneratedCertificateItem({
    super.key,
    required this.role,
    required this.certName,
    required this.userName,
    required this.issueDate,
    required this.isSent,
    required this.onSend,
    required this.onDeleteRequest,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onDeleteRequest,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CertificateCard(
            role: role,
            certName: certName,
            userName: userName,
            issueDate: issueDate,
          ),

          if (!isSent)
            IgnorePointer(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          if (!isSent)
            Positioned(
              bottom: 16,
              child: GestureDetector(
                onTap: onSend,
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.secondaryDark,
                        AppColors.primaryLight.withValues(alpha: 0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondaryDark.withValues(alpha: 0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    LucideIcons.send,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
