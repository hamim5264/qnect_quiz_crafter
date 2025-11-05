import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class CertificateCard extends StatelessWidget {
  final String role;
  final String certName;
  final String userName;
  final String issueDate;

  const CertificateCard({
    super.key,
    required this.role,
    required this.certName,
    required this.userName,
    this.issueDate = 'N/A',
  });

  @override
  Widget build(BuildContext context) {
    final idPrefix = role == 'Teacher' ? 'QC-T' : 'QC-S';
    final idNumber = _getIdNumber(certName);
    final suffix = _lastTwoLetters(userName);
    final certId = '$idPrefix-$idNumber$suffix';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.white, AppColors.cardSecondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        image: const DecorationImage(
          image: AssetImage(
            'assets/images/certificates/certificate_background.png',
          ),
          fit: BoxFit.cover,
          opacity: 0.05,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID: $certId',
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
              Image.asset(
                'assets/images/certificates/app_logo.png',
                height: 50,
              ),
            ],
          ),

          const SizedBox(height: 10),

          Image.asset(_getCertificateImagePath(certName, role), height: 65),
          const SizedBox(height: 8),

          Text(
            certName.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.teal,
              fontFamily: 'Aboreto',
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 3),
          const Text(
            'CERTIFICATE',
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Certificate of Teaching',
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 13,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 8),
          Text(
            certName,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13,
                fontFamily: AppTypography.family,
                color: Colors.black87,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
              children: _getStyledDescription(certName, userName),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  QrImageView(
                    data: certId,
                    size: 50,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Issue Date: $issueDate',
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/certificates/admin_sign.png',
                    height: 30,
                  ),
                  const Text(
                    'Signature\n(Admin & Founder)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                      fontFamily: AppTypography.family,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/certificates/sub_admin_sign.png',
                    height: 30,
                  ),
                  const Text(
                    'Signature\n(Sub-Admin)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                      fontFamily: AppTypography.family,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getIdNumber(String cert) {
    final lower = cert.toLowerCase();
    if (lower.contains('foundation')) return '1';
    if (lower.contains('advanced')) return '2';
    if (lower.contains('master') || lower.contains('legend')) return '3';
    return '0';
  }

  String _lastTwoLetters(String name) {
    final compact = name.replaceAll(RegExp(r'\s+'), '');
    if (compact.isEmpty) return 'XX';
    final start = compact.length >= 2 ? compact.length - 2 : 0;
    return compact.substring(start).toUpperCase();
  }

  String _getCertificateImagePath(String cert, String role) {
    final lower = cert.toLowerCase();
    if (role == 'Teacher') {
      if (lower.contains('foundation')) {
        return 'assets/images/certificates/teacher_certificate_1.png';
      } else if (lower.contains('advanced')) {
        return 'assets/images/certificates/teacher_certificate_2.png';
      } else {
        return 'assets/images/certificates/teacher_certificate_3.png';
      }
    } else {
      if (lower.contains('foundation')) {
        return 'assets/images/certificates/student_certificate_1.png';
      } else if (lower.contains('advanced')) {
        return 'assets/images/certificates/student_certificate_2.png';
      } else {
        return 'assets/images/certificates/student_certificate_3.png';
      }
    }
  }

  List<TextSpan> _getStyledDescription(String cert, String name) {
    String text;
    final lower = cert.toLowerCase();
    if (lower.contains('foundation')) {
      text =
          'QuizCrafter certifies that $name has successfully completed Levels 1–5 demonstrating course design, fair assessments, and positive engagement.';
    } else if (lower.contains('advanced')) {
      text =
          'In recognition of sustained excellence in content and learner impact, $name has achieved Levels 6–10 on the track.';
    } else {
      text =
          'For completing all 12 levels and upholding QuizCrafter’s standards, this certificate recognizes $name as a Master Educator.';
    }
    final parts = text.split(name);
    return [
      TextSpan(text: parts.first),
      TextSpan(text: name, style: const TextStyle(fontWeight: FontWeight.bold)),
      if (parts.length > 1) TextSpan(text: parts.last),
    ];
  }
}

class CertificateRoleFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const CertificateRoleFilter({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final roles = ['Teacher', 'Student'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          roles.map((role) {
            final bool isSelected = role == selected;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: isSelected ? 10 : 0,
                      sigmaY: isSelected ? 10 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => onSelected(role),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.white.withValues(alpha: 0.18)
                                  : Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppColors.secondaryDark
                                    : Colors.transparent,
                            width: 1.2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            role,
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
