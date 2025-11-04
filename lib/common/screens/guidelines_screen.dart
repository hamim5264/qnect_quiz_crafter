import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/common_rounded_app_bar.dart';
import '../../ui/design_system/tokens/colors.dart';
import '../../ui/design_system/tokens/typography.dart';

class GuidelinesScreen extends StatefulWidget {
  const GuidelinesScreen({super.key});

  @override
  State<GuidelinesScreen> createState() => _GuidelinesScreenState();
}

class _GuidelinesScreenState extends State<GuidelinesScreen> {
  bool teacherOpen = false;
  bool studentOpen = false;
  bool privacyOpen = false;
  bool purchaseOpen = false;
  bool violationOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CommonRoundedAppBar(
        title: 'Guidelines',
        onBack: () => context.pop(),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Teach With Integrity. Learn With Purpose.",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 18),

            _sectionHeader("Teacher Guidelines", teacherOpen, () {
              setState(() => teacherOpen = !teacherOpen);
            }),
            if (teacherOpen)
              _whiteBox([
                "Syllabus & quality: Align to curriculum; keep facts accurate.",
                "Fair assessments: Balanced difficulty; add short solutions.",
                "Responsible AI: Draft using tools, review manually.",
                "Licensed media only; avoid copyrighted content.",
                "Professional tone.",
                "No off-platform sales.",
              ]),

            _sectionHeader("Student Guidelines", studentOpen, () {
              setState(() => studentOpen = !studentOpen);
            }),
            if (studentOpen)
              _whiteBox([
                "Academic integrity: No cheating or sharing answers.",
                "Be quiz-ready: Check device, time, network.",
                "Respectful reviews/messages.",
                "Personal access only; don’t share paid content.",
                "Account safety: strong passwords.",
              ]),

            _sectionHeader("Privacy & Policy", privacyOpen, () {
              setState(() => privacyOpen = !privacyOpen);
            }),
            if (privacyOpen)
              _whiteBox([
                "We collect: Name, email, avatar, analytics; payment metadata.",
                "Secure storage (encrypted, limited access).",
                "Payment processors only see required info.",
                "You control: update profile, export/delete account.",
              ]),

            _sectionHeader("Course Purchases", purchaseOpen, () {
              setState(() => purchaseOpen = !purchaseOpen);
            }),
            if (purchaseOpen)
              _whiteBox([
                "Personal access only.",
                "Refunds: 48h if <10% content used.",
                "Taxes & FX fees may apply.",
                "Misuse/chargebacks → access paused.",
                "Content rights remain with teachers.",
              ]),

            _sectionHeader("Violations", violationOpen, () {
              setState(() => violationOpen = !violationOpen);
            }),
            if (violationOpen)
              _whiteBox(["Warnings → temporary restrictions → suspension"]),

            const SizedBox(height: 28),
            const Center(
              child: Text(
                "Thank You",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, bool open, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(
              open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.secondaryDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _whiteBox(List<String> points) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: points.map((e) => _bullet(e)).toList(),
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(color: AppColors.secondaryDark, fontSize: 16),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
                fontSize: 13.5,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
