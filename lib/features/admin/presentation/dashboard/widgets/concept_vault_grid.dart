import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lottie/lottie.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class ConceptVaultGrid extends StatefulWidget {
  const ConceptVaultGrid({super.key});

  @override
  State<ConceptVaultGrid> createState() => _ConceptVaultGridState();
}

class _ConceptVaultGridState extends State<ConceptVaultGrid> {
  bool _showComingSoon = false;

  void _showComingSoonOverlay() async {
    setState(() => _showComingSoon = true);

    await Future.delayed(const Duration(seconds: 4));

    setState(() => _showComingSoon = false);
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'Lecture Stream',
        'subtitle': 'Host or Watch Class Videos',
        'icon': LucideIcons.video,
      },
      {
        'title': 'PDF Vault',
        'subtitle': 'Store All PDFs Securely',
        'icon': LucideIcons.fileText,
      },
      {
        'title': 'BookBazaar',
        'subtitle': 'Discover New Books',
        'icon': LucideIcons.book,
      },
      {
        'title': 'QuizRumble',
        'subtitle': 'Compete with Friends',
        'icon': LucideIcons.zap,
      },
    ];

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Concept Vault',
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    items.map((e) {
                      return GestureDetector(
                        onTap: _showComingSoonOverlay,
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          height: 72,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  e['icon'] as IconData,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      e['title'] as String,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontFamily: AppTypography.family,
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      e['subtitle'] as String,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: AppTypography.family,
                                        color: AppColors.textPrimary.withValues(
                                          alpha: 0.8,
                                        ),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.chip2,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(LucideIcons.share2, color: AppColors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Share App',
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
