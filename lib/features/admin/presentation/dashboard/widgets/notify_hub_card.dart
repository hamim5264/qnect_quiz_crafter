import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
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
      'title': 'Exam Schedule Published',
      'audience': 'Students',
      'subtitle':
          'The final exam routine has been uploaded. Check your dashboard for updated timing...',
      'time': '6 Nov 2025, 10:45 AM',
    },
    {
      'title': 'Meeting Reminder',
      'audience': 'Teachers',
      'subtitle':
          'All teachers must attend today’s academic council meeting at 3:00 PM in Conference Hall...',
      'time': '5 Nov 2025, 8:30 AM',
    },
    {
      'title': 'Server Maintenance',
      'audience': 'All Users',
      'subtitle':
          'System will be down for maintenance from 12:00 AM to 2:00 AM. Please avoid submissions...',
      'time': '4 Nov 2025, 11:00 PM',
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
            itemBuilder: (context, index, _) {
              final n = notices[index];
              return _NoticeCard(
                title: n['title']!,
                audience: n['audience']!,
                subtitle: n['subtitle']!,
                time: n['time']!,
                onTap: () => context.push('/notify-hub'),
              );
            },
            options: CarouselOptions(
              height: 250,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (i, _) => setState(() => _currentIndex = i),
            ),
          ),

          const SizedBox(height: 10),

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
  final String time;
  final VoidCallback onTap;

  const _NoticeCard({
    required this.title,
    required this.audience,
    required this.subtitle,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Notice Icon
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.campaign_rounded,
              color: AppColors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.w700,
              fontSize: 15.5,
              color: AppColors.secondaryDark,
            ),
          ),
          const SizedBox(height: 5),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 12.5,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            'Delivered at: $time',
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 11.5,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Chip(text: audience, color: AppColors.primaryLight),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.chip2,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.arrowRightCircle,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'See Full Notice',
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color color;

  const _Chip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: AppTypography.family,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
