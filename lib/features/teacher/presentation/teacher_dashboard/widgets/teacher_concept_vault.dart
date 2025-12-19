import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class TeacherConceptVaultSection extends StatefulWidget {
  final List<TeacherConceptVaultItem> items;

  const TeacherConceptVaultSection({super.key, required this.items});

  @override
  State<TeacherConceptVaultSection> createState() =>
      _TeacherConceptVaultSectionState();
}

class _TeacherConceptVaultSectionState
    extends State<TeacherConceptVaultSection> {
  bool _showComingSoon = false;

  Future<void> _showComingSoonOverlay() async {
    setState(() => _showComingSoon = true);
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) setState(() => _showComingSoon = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Concept Vault",
              style: TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox.shrink(),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 70,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final item = widget.items[index];

                return GestureDetector(
                  onTap: _showComingSoonOverlay,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.chip2.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: item.icon,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontFamily: AppTypography.family,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: AppTypography.family,
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        if (_showComingSoon)
          Positioned.fill(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.5,
                    color: Colors.black.withValues(alpha: 0.4),
                    alignment: Alignment.center,
                    child: Lottie.asset(
                      'assets/icons/coming_soon.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class TeacherConceptVaultItem {
  final String title;
  final String subtitle;
  final Widget icon;
  final VoidCallback onTap;

  TeacherConceptVaultItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}
