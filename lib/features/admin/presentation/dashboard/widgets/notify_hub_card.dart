import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class NotifyHubCard extends StatefulWidget {
  const NotifyHubCard({super.key});

  @override
  State<NotifyHubCard> createState() => _NotifyHubCardState();
}

class _NotifyHubCardState extends State<NotifyHubCard> {
  int _currentIndex = 0;

  final List<Map<String, String>> notices = [
    {
      'title': 'System Maintenance',
      'audience': 'For All Teachers & Students',
      'subtitle': 'Delivered at: 2025-09-15 00:30 (BST)',
    },
    {
      'title': 'New Quiz Update',
      'audience': 'For Teachers Only',
      'subtitle': 'Delivered at: 2025-10-02 08:45 (BST)',
    },
    {
      'title': 'Holiday Notice',
      'audience': 'For All Users',
      'subtitle': 'Delivered at: 2025-10-25 09:00 (BST)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notify Hub',
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          CarouselSlider.builder(
            itemCount: notices.length,
            itemBuilder: (context, index, realIdx) {
              final notice = notices[index];
              return _NoticeCard(
                title: notice['title']!,
                audience: notice['audience']!,
                subtitle: notice['subtitle']!,
                onTap: () {
                  // Navigate to detailed notice screen
                },
              );
            },
            options: CarouselOptions(
              height: 115,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (i, _) => setState(() => _currentIndex = i),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              notices.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      _currentIndex == index ? AppColors.chip1 : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final String title;
  final String audience;
  final String subtitle;
  final VoidCallback onTap;

  const _NoticeCard({
    required this.title,
    required this.audience,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.campaign_rounded,
              color: AppColors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.secondaryDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  audience,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.secondaryDark,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.arrowRight,
                color: Colors.black,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
