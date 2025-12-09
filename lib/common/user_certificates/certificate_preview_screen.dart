import 'package:flutter/material.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../features/admin/presentation/certificates/widgets/certificate_card.dart';

class UserCertificatePreviewScreen extends StatelessWidget {
  final String certName;
  final String userName;
  final String role;        // Teacher / Student
  final String issueDate;

  const UserCertificatePreviewScreen({
    super.key,
    required this.certName,
    required this.userName,
    required this.role,
    required this.issueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Certificate Preview"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: CertificateCard(
            role: role,
            certName: certName,
            userName: userName,
            issueDate: issueDate,
          ),
        ),
      ),
    );
  }
}
