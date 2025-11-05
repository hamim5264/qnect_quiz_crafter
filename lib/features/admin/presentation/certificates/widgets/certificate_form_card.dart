import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import 'certificate_input_field.dart';

class CertificateFormData {
  final String role;
  final String user;
  final String certName;
  final DateTime? date;

  const CertificateFormData({
    required this.role,
    required this.user,
    required this.certName,
    required this.date,
  });

  bool get isComplete =>
      role.isNotEmpty && user.isNotEmpty && certName.isNotEmpty && date != null;
}

class CertificateFormCard extends StatefulWidget {
  final ValueChanged<CertificateFormData>? onChanged;

  const CertificateFormCard({super.key, this.onChanged});

  @override
  State<CertificateFormCard> createState() => _CertificateFormCardState();
}

class _CertificateFormCardState extends State<CertificateFormCard> {
  String selectedRole = 'Student';
  String selectedCertificate = '';
  String selectedUser = '';
  DateTime? selectedDate;

  final List<String> teacherCerts = [
    'Foundation Educator',
    'Advanced Educator',
    'Master Educator',
  ];
  final List<String> studentCerts = [
    'Foundation Learner',
    'Advanced Scholar',
    'Legend Learner',
  ];

  final List<String> teacherUsers = [
    'Hasna Hena',
    'Arpita Ghose',
    'Jannat Mim',
    'Tushar Roy',
  ];
  final List<String> studentUsers = [
    'Rafiul Islam',
    'Sadia Rahman',
    'Tuhin Ahamed',
    'Shafin Alam',
  ];

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.secondaryDark,
              surface: AppColors.primaryLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
      _emit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final certList = selectedRole == 'Teacher' ? teacherCerts : studentCerts;
    final userList = selectedRole == 'Teacher' ? teacherUsers : studentUsers;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white30),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CertificateInputField(
            label: 'Select user role',
            icon: CupertinoIcons.chevron_up_chevron_down,
            value: selectedRole,
            onTap: () async {
              await showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.primaryLight,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder:
                    (_) => ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      children: [
                        _roleOption('Student'),
                        _roleOption('Teacher'),
                      ],
                    ),
              );
            },
          ),

          CertificateInputField(
            label:
                selectedUser.isEmpty
                    ? 'Presented to (user name)'
                    : selectedUser,
            icon: Icons.person_search_rounded,
            onTap: () async {
              await showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.primaryLight,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          userList[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: AppTypography.family,
                          ),
                        ),
                        onTap: () {
                          setState(() => selectedUser = userList[index]);
                          Navigator.pop(context);
                          _emit();
                        },
                      );
                    },
                  );
                },
              );
            },
          ),

          CertificateInputField(
            label:
                selectedCertificate.isEmpty
                    ? 'Select certificate'
                    : selectedCertificate,
            icon: Icons.badge_rounded,
            onTap: () async {
              await showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.primaryLight,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder:
                    (_) => ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      children:
                          certList
                              .map((cert) => _certificateOption(cert))
                              .toList(),
                    ),
              );
            },
          ),

          CertificateInputField(
            label:
                selectedDate == null
                    ? 'Enter date'
                    : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
            icon: CupertinoIcons.calendar,
            onTap: () => pickDate(context),
          ),
        ],
      ),
    );
  }

  Widget _roleOption(String role) {
    return ListTile(
      title: Text(
        role,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: AppTypography.family,
        ),
      ),
      onTap: () {
        setState(() {
          selectedRole = role;
          selectedCertificate = '';
          selectedUser = '';
        });
        Navigator.pop(context);
        _emit();
      },
    );
  }

  Widget _certificateOption(String cert) {
    return ListTile(
      title: Text(
        cert,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: AppTypography.family,
        ),
      ),
      onTap: () {
        setState(() => selectedCertificate = cert);
        Navigator.pop(context);
        _emit();
      },
    );
  }

  void _emit() {
    widget.onChanged?.call(
      CertificateFormData(
        role: selectedRole,
        user: selectedUser,
        certName: selectedCertificate,
        date: selectedDate,
      ),
    );
  }
}
