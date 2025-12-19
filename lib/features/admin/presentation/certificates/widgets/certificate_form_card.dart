import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import 'certificate_input_field.dart';

class CertificateFormData {
  final String role;
  final String userId;
  final String user;
  final String certName;
  final DateTime? date;

  const CertificateFormData({
    required this.role,
    required this.userId,
    required this.user,
    required this.certName,
    required this.date,
  });

  bool get isComplete =>
      role.isNotEmpty &&
      userId.isNotEmpty &&
      user.isNotEmpty &&
      certName.isNotEmpty &&
      date != null;
}

class CertificateFormCard extends StatefulWidget {
  final ValueChanged<CertificateFormData>? onChanged;

  const CertificateFormCard({super.key, this.onChanged});

  @override
  State<CertificateFormCard> createState() => _CertificateFormCardState();
}

class _CertificateFormCardState extends State<CertificateFormCard> {
  String selectedRole = 'Student';

  String selectedUserName = '';
  String selectedUserId = '';
  int? selectedUserLevel;

  String selectedCertificate = '';
  DateTime? selectedDate;

  final List<String> teacherCerts = const [
    'Foundation Educator',
    'Advanced Educator',
    'Master Educator',
  ];

  final List<String> studentCerts = const [
    'Foundation Learner',
    'Advanced Scholar',
    'Legend Learner',
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
                selectedUserName.isEmpty
                    ? 'Presented to (user name)'
                    : selectedUserName,
            icon: Icons.person_search_rounded,
            onTap: () => _selectUser(context),
          ),

          CertificateInputField(
            label:
                selectedCertificate.isEmpty
                    ? 'Select certificate'
                    : selectedCertificate,
            icon: Icons.badge_rounded,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Certificate is auto-selected based on this user's level.",
                  ),
                ),
              );
            },
          ),

          CertificateInputField(
            label:
                selectedDate == null
                    ? 'Enter date'
                    : '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}',
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
          selectedUserName = '';
          selectedUserId = '';
          selectedUserLevel = null;
          selectedCertificate = '';
        });
        Navigator.pop(context);
        _emit();
      },
    );
  }

  String _buildName(Map<String, dynamic> data) {
    final first = (data['firstName'] ?? '').toString().trim();
    final last = (data['lastName'] ?? '').toString().trim();

    if (first.isEmpty && last.isEmpty) {
      return "Unknown User";
    }
    return "$first $last".trim();
  }

  Future<void> _selectUser(BuildContext context) async {
    final roleLower = selectedRole.toLowerCase();

    final snap =
        await FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: roleLower)
            .get();

    if (!mounted) return;

    if (snap.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "No $roleLower accounts found.",
            style: const TextStyle(fontFamily: AppTypography.family),
          ),
        ),
      );
      return;
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snap.docs.length,
          itemBuilder: (context, index) {
            final doc = snap.docs[index];
            final data = doc.data();

            final name = _buildName(data);

            final dynamic rawLevel = data['level'];
            final int level = int.tryParse(rawLevel?.toString() ?? '') ?? 1;

            return ListTile(
              title: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: AppTypography.family,
                ),
              ),
              subtitle: Text(
                'Level $level',
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: AppTypography.family,
                  fontSize: 12,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedUserName = name;
                  selectedUserId = doc.id;
                  selectedUserLevel = level;
                });
                Navigator.pop(context);
                _resolveCertificateEligibility();
              },
            );
          },
        );
      },
    );
  }

  void _resolveCertificateEligibility() {
    if (selectedUserLevel == null) {
      setState(() => selectedCertificate = '');
      _emit();
      return;
    }

    final cert = _eligibleCertificateFor(selectedRole, selectedUserLevel ?? 1);

    setState(() => selectedCertificate = cert ?? '');
    _emit();

    if (cert == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "This user is not eligible for any certificate yet.",
            style: const TextStyle(fontFamily: AppTypography.family),
          ),
        ),
      );
    }
  }

  String? _eligibleCertificateFor(String roleUi, int level) {
    final isTeacher = roleUi == 'Teacher';

    if (level >= 1 && level <= 5) {
      return isTeacher ? teacherCerts[0] : studentCerts[0];
    } else if (level >= 6 && level <= 10) {
      return isTeacher ? teacherCerts[1] : studentCerts[1];
    } else if (level > 10) {
      return isTeacher ? teacherCerts[2] : studentCerts[2];
    }
    return null;
  }

  void _emit() {
    widget.onChanged?.call(
      CertificateFormData(
        role: selectedRole,
        userId: selectedUserId,
        user: selectedUserName,
        certName: selectedCertificate,
        date: selectedDate,
      ),
    );
  }
}
