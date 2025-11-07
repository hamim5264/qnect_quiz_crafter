import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class TeacherRequestInfoCard extends StatefulWidget {
  final String email, dob, phone, address, resume, status;

  const TeacherRequestInfoCard({
    super.key,
    required this.email,
    required this.dob,
    required this.phone,
    required this.address,
    required this.resume,
    required this.status,
  });

  @override
  State<TeacherRequestInfoCard> createState() => _TeacherRequestInfoCardState();
}

class _TeacherRequestInfoCardState extends State<TeacherRequestInfoCard> {
  Future<void> _openResumeLink() async {
    final uri = Uri.parse(widget.resume);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        debugPrint('⚠️ Could not open: $uri');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No browser found to open the link.')),
        );
      }
    } catch (e) {
      debugPrint('❌ Error launching URL: $e');
    }
  }

  Future<void> _sendMail() async {
    final Uri mail = Uri(scheme: 'mailto', path: widget.email);
    try {
      final launched = await launchUrl(
        mail,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        debugPrint('⚠️ Could not open mail client');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No email app found.')));
      }
    } catch (e) {
      debugPrint('❌ Error launching mail client: $e');
    }
  }

  String _shortenLink(String url) {
    if (url.length > 25) {
      return '${url.substring(0, 6)}...${url.substring(url.length - 10)}';
    }
    return url;
  }

  Widget _buildRow(
    String key,
    String value, {
    bool isLink = false,
    bool isEmail = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.chip3,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  key,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            Flexible(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: isLink ? _openResumeLink : null,
                        child: Text(
                          isLink ? _shortenLink(value) : value,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            fontSize: 13,
                            color: isLink ? Colors.blueAccent : Colors.black87,
                            decoration:
                                isLink ? TextDecoration.underline : null,
                          ),
                        ),
                      ),
                    ),
                    if (isEmail)
                      GestureDetector(
                        onTap: _sendMail,
                        child: Row(
                          children: const [
                            Icon(
                              CupertinoIcons.mail,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Send",
                              style: TextStyle(
                                fontFamily: AppTypography.family,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildRow('Email', widget.email, isEmail: true),
          _buildRow('DOB', widget.dob),
          _buildRow('Phone', widget.phone),
          _buildRow('Address', widget.address),
          _buildRow('Resume Link', widget.resume, isLink: true),
          _buildRow('Status', widget.status),
        ],
      ),
    );
  }
}
