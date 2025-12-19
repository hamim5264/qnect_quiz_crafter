import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnect_quiz_crafter/common/screens/notification/providers/notification_provider.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';

import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import 'widgets/notification_card.dart';

class NotificationScreen extends ConsumerWidget {
  final String role;
  final String? uid;

  const NotificationScreen({super.key, required this.role, this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String userKey = (role == "admin") ? "admin" : uid!;
    final String docId = (role == "admin") ? "admin-panel" : uid!;

    final notificationsAsync = ref.watch(notificationProvider(userKey));

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Notifications'),
      body: notificationsAsync.when(
        loading: () => const Center(child: AppLoader()),
        error:
            (e, _) => Center(
              child: Text(
                'Error: $e',
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: AppTypography.family,
                ),
              ),
            ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white70,
                      size: 80,
                    ),
                  ),
                  Text(
                    'No Notifications',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: AppTypography.family,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];

              final String type = (item['type'] as String?) ?? '';

              String title;
              String description;

              if (type == 'course_sold') {
                final amount = item['amount']?.toString() ?? '0';
                final courseId = item['courseId']?.toString() ?? '';
                final studentId = item['studentId']?.toString() ?? '';

                title = 'Course Sold';
                description =
                    'A course ($courseId) was purchased by student $studentId for ৳$amount.';
              } else if (type == 'teacher_rejected') {
                final name = item['name']?.toString() ?? 'Teacher';
                final reason =
                    item['reason']?.toString() ?? 'No reason provided.';
                title = 'Teacher Request Rejected';
                description = '$name was rejected. Reason: $reason';
              } else {
                title = (item['title'] as String?) ?? 'Notification';
                description = (item['description'] as String?) ?? '';
              }

              final bool isRead = (item['isRead'] as bool?) ?? false;

              return NotificationCard(
                title: title,
                description: description,
                isRead: isRead,
                onMarkRead: () {
                  FirebaseFirestore.instance
                      .collection('notifications')
                      .doc(docId)
                      .collection('items')
                      .doc(item['id'] as String)
                      .update({'isRead': true});
                },
                onDelete: () {
                  FirebaseFirestore.instance
                      .collection('notifications')
                      .doc(docId)
                      .collection('items')
                      .doc(item['id'] as String)
                      .delete();
                },
              );
            },
          );
        },
      ),
    );
  }
}
