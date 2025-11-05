import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/certificates/widgets/generated_certificate_item.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class GeneratedCertificatesScreen extends StatefulWidget {
  final List<Map<String, String>>? certificates;

  const GeneratedCertificatesScreen({super.key, this.certificates});

  @override
  State<GeneratedCertificatesScreen> createState() =>
      _GeneratedCertificatesScreenState();
}

class _GeneratedCertificatesScreenState
    extends State<GeneratedCertificatesScreen> {
  late List<Map<String, String>> _certs;
  final Set<int> _sent = {};

  @override
  void initState() {
    super.initState();
    _certs = List<Map<String, String>>.from(widget.certificates ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Generated Certificates'),
      body: SafeArea(
        child:
            _certs.isEmpty
                ? _emptyState()
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _certs.length,
                  itemBuilder: (context, i) {
                    final c = _certs[i];
                    final sent = _sent.contains(i);
                    return GeneratedCertificateItem(
                      role: c['role'] ?? '',
                      certName: c['certName'] ?? '',
                      userName: c['userName'] ?? '',
                      issueDate: c['issueDate'] ?? 'N/A',
                      isSent: sent,
                      onSend: () {
                        setState(() => _sent.add(i));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.secondaryDark,
                            content: Text(
                              'Certificate sent to ${c['userName']}!',
                              style: const TextStyle(
                                fontFamily: AppTypography.family,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                      onDeleteRequest: () => _confirmDelete(i),
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

  void _confirmDelete(int index) async {
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
                onPressed: () => Navigator.pop(context, true),
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
      setState(() {
        _certs.removeAt(index);
        _sent.remove(index);
      });
    }
  }
}
