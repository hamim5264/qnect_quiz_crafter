import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import 'data/app_ratings_providers.dart';
import 'widgets/ratings_summary_box.dart';
import 'widgets/ratings_card.dart';

class AppRatingsScreen extends ConsumerWidget {
  const AppRatingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleAsync = ref.watch(ratingsRoleProvider);
    final ratingsAsync = ref.watch(appRatingsProvider);
    final summary = ref.watch(appRatingsSummaryProvider);

    final role = roleAsync.value;
    final isAdmin = role == 'admin';

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'App Ratings'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              RatingsSummaryBox(
                total: summary['total'] as int,
                performanceAvg: summary['performanceAvg'] as double,
                privacyAvg: summary['privacyAvg'] as double,
                experienceAvg: summary['experienceAvg'] as double,
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ratingsAsync.when(
                  loading:
                      () => const Center(child: CupertinoActivityIndicator()),
                  error:
                      (_, __) => const Center(
                        child: Text(
                          'Failed to load ratings',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                  data:
                      (list) => ListView.separated(
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final r = list[i];

                          return RatingsCard(
                            name: (r['userName'] ?? '').toString(),
                            avatar: (r['profileImage'] ?? '').toString(),
                            performance: (r['performance'] ?? 0) as int,
                            privacy: (r['privacy'] ?? 0) as int,
                            experience: (r['experience'] ?? 0) as int,
                            comment: (r['comment'] ?? '').toString(),
                            onDelete:
                                isAdmin
                                    ? () async {
                                      await FirebaseFirestore.instance
                                          .collection('app_ratings')
                                          .doc(r['id'])
                                          .delete();
                                      if (context.mounted)
                                        Navigator.pop(context);
                                    }
                                    : null,
                          );
                        },
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
