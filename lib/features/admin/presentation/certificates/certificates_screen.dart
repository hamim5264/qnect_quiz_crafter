import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../../../../../common/widgets/app_loader.dart';
import '../../../../../common/widgets/success_failure_dialog.dart';
import 'widgets/certificate_form_card.dart';

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  bool _isLoading = false;
  CertificateFormData _form = const CertificateFormData(
    role: 'Student',
    user: '',
    certName: '',
    date: null,
  );

  final List<Map<String, String>> _generatedCertificates = [];

  Future<void> _generateCertificate() async {
    if (!_form.isComplete) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    final issue = _formatDate(_form.date!);

    _generatedCertificates.add({
      'role': _form.role,
      'certName': _form.certName,
      'userName': _form.user,
      'issueDate': issue,
    });

    setState(() => _isLoading = false);

    showDialog(
      context: context,
      builder:
          (_) => SuccessFailureDialog(
            icon: Icons.check_circle_rounded,
            title: "Certificate Generated!",
            subtitle:
                "Your certificate has been successfully generated.\nYou can view it in Generated Certificates.",
            buttonText: "View Generated",
            onPressed: () {
              Navigator.pop(context);
              context.pushNamed(
                'generatedCertificates',
                extra: _generatedCertificates,
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = !_form.isComplete;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.primaryDark,
          appBar: const CommonRoundedAppBar(title: 'Certificates'),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CertificateFormCard(
                    onChanged: (data) => setState(() => _form = data),
                  ),
                  const SizedBox(height: 26),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: disabled ? null : _generateCertificate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            disabled
                                ? AppColors.secondaryDark.withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.85),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Generate Certificate',
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  _buildButton(
                    label: 'View Templates',
                    bgColor: AppColors.secondaryDark,
                    textColor: AppColors.textPrimary,
                    onTap: () => context.pushNamed('certificateTemplates'),
                  ),
                  const SizedBox(height: 14),
                  _buildButton(
                    label: 'View Generated Certificate',
                    bgColor: AppColors.secondaryDark,
                    textColor: AppColors.textPrimary,
                    onTap:
                        () => context.pushNamed(
                          'generatedCertificates',
                          extra: _generatedCertificates,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),

        if (_isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.6),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppLoader(size: 70),
                  SizedBox(height: 18),
                  Text(
                    "Generating your certificate...",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppTypography.family,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}
