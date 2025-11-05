import 'package:flutter/material.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import 'widgets/ratings_summary_box.dart';
import 'widgets/ratings_card.dart';

class AppRatingsScreen extends StatelessWidget {
  const AppRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ratings = [
      {
        'name': 'John Doe',
        'avatar': 'assets/images/admin/sample_teacher.png',
        'performance': 4,
        'privacy': 3,
        'experience': 5,
        'comment':
            'All course are perfectly aligned and teachers learning system is very well. Recommended this app for new learner.',
      },
      {
        'name': 'Tasnim',
        'avatar': 'assets/images/admin/sample_teacher3.png',
        'performance': 4,
        'privacy': 3,
        'experience': 5,
        'comment':
            'All course are perfectly aligned and teachers learning system is very well. Recommended this app for new learner.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'App Ratings'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const RatingsSummaryBox(
                total: 219,
                performanceAvg: 4.7,
                privacyAvg: 4.7,
                experienceAvg: 4.7,
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView.separated(
                  itemCount: ratings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final item = ratings[index];
                    return RatingsCard(
                      name: item['name'] as String,
                      avatar: item['avatar'] as String,
                      performance: item['performance'] as int,
                      privacy: item['privacy'] as int,
                      experience: item['experience'] as int,
                      comment: item['comment'] as String,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
