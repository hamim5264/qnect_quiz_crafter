import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/user_certificates/user_certificates_controller.dart';


class UserCertificateListItem extends StatelessWidget {
  final UserCertificate cert;

  const UserCertificateListItem({super.key, required this.cert});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          "/certificate-preview",
          extra: cert,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cert.certName,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Issued on ${cert.issueDate}",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
