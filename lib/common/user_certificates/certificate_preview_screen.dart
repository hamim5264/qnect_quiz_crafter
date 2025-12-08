import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/common/user_certificates/user_certificates_controller.dart';

class CertificatePreviewScreen extends StatelessWidget {
  final UserCertificate cert;

  const CertificatePreviewScreen({super.key, required this.cert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00332c),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Certificate Preview",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: UserCertificate(id: id, certName: certName, issueDate: issueDate, levelGroup: levelGroup)
      ),
    );
  }
}
