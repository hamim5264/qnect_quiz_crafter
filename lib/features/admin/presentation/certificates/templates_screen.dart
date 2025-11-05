import 'package:flutter/material.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import 'widgets/certificate_card.dart';

class CertificateTemplatesScreen extends StatefulWidget {
  const CertificateTemplatesScreen({super.key});

  @override
  State<CertificateTemplatesScreen> createState() =>
      _CertificateTemplatesScreenState();
}

class _CertificateTemplatesScreenState
    extends State<CertificateTemplatesScreen> {
  String selectedFilter = 'Teacher';

  @override
  Widget build(BuildContext context) {
    final teacherTemplates = [
      'Foundation Educator',
      'Advanced Educator',
      'Master Educator',
    ];
    final studentTemplates = [
      'Foundation Learner',
      'Advanced Scholar',
      'Legend Learner',
    ];

    final templates =
        selectedFilter == 'Teacher' ? teacherTemplates : studentTemplates;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Certificate Templates'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CertificateRoleFilter(
                selected: selectedFilter,
                onSelected: (value) {
                  setState(() => selectedFilter = value);
                },
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    return CertificateCard(
                      role: selectedFilter,
                      certName: templates[index],
                      userName: 'Hasna Hena',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
