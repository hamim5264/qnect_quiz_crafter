import 'package:flutter/material.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Quiz Result Published',
      'desc':
          'Your quiz “English Grammar Basics” result has been published. Check your dashboard for details.',
      'read': false,
    },
    {
      'title': 'New Course Assigned',
      'desc':
          'A new course “Advanced Speaking Skills” has been added to your account.',
      'read': true,
    },
    {
      'title': 'Account Update',
      'desc':
          'Your profile information has been successfully updated. Thank you for keeping your data current.',
      'read': false,
    },
  ];

  void _markAsRead(int index) {
    setState(() => notifications[index]['read'] = true);
  }

  void _delete(int index) {
    setState(() => notifications.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Notifications'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = notifications[index];
              return NotificationCard(
                title: item['title'] as String,
                description: item['desc'] as String,
                isRead: item['read'] as bool,
                onMarkRead: () => _markAsRead(index),
                onDelete: () => _delete(index),
              );
            },
          ),
        ),
      ),
    );
  }
}
