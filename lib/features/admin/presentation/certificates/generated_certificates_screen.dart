import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/certificates/widgets/generated_certificate_item.dart';

import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class GeneratedCertificatesScreen extends StatelessWidget {
  final List<Map<String, String>>? certificates;

  const GeneratedCertificatesScreen({super.key, this.certificates});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Generated Certificates'),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('certificates')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.secondaryDark,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load certificates',
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.redAccent,
                  ),
                ),
              );
            }

            final docs = snapshot.data?.docs ?? [];

            if (docs.isEmpty) {
              return _emptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (context, i) {
                final doc = docs[i];
                final data = doc.data() as Map<String, dynamic>;

                final role = (data['role'] ?? '') as String;
                final uiRole =
                    role.toLowerCase() == 'teacher' ? 'Teacher' : 'Student';

                final certName = (data['certName'] ?? '') as String;
                final userName = (data['userName'] ?? '') as String;
                final issueDate = (data['issueDate'] ?? 'N/A') as String;
                final isSent = (data['isSent'] ?? false) as bool;

                return GeneratedCertificateItem(
                  role: uiRole,
                  certName: certName,
                  userName: userName,
                  issueDate: issueDate,
                  isSent: isSent,
                  onSend: () => _handleSend(context, doc.id, data),
                  onDeleteRequest: () => _confirmDelete(context, doc.id),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _emptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primaryLight,
          child: Icon(Icons.close_rounded, color: Colors.white, size: 44),
        ),
        SizedBox(height: 14),
        Text(
          'No certificate generated yet',
          style: TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white70,
            fontSize: 15,
          ),
        ),
      ],
    ),
  );

  Future<void> _handleSend(
    BuildContext context,
    String certId,
    Map<String, dynamic> data,
  ) async {
    try {
      final firestore = FirebaseFirestore.instance;

      await firestore.collection('certificates').doc(certId).update({
        'isSent': true,
      });

      final String userId = (data['userId'] ?? '') as String;
      if (userId.isNotEmpty) {
        await firestore
            .collection('notifications')
            .doc(userId)
            .collection('items')
            .add({
              'type': 'certificate',
              'title': 'New Certificate Earned!',
              'message':
                  'You have received the ${(data['certName'] ?? 'certificate')}.',
              'createdAt': FieldValue.serverTimestamp(),
            });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryLight,
          content: Text(
            'Certificate sent to ${data['userName'] ?? 'user'}!',
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white,
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Failed to send certificate: $e',
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  void _confirmDelete(BuildContext context, String certId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: AppColors.primaryLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Delete certificate?',
              style: TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'This action cannot be undone.',
              style: TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white70,
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (ok == true) {
      try {
        await FirebaseFirestore.instance
            .collection('certificates')
            .doc(certId)
            .delete();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Failed to delete: $e',
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    }
  }
}
