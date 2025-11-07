import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../common/widgets/common_confirm_dialog.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import 'widgets/notify_card.dart';

class NotifyHubScreen extends StatefulWidget {
  const NotifyHubScreen({super.key});

  @override
  State<NotifyHubScreen> createState() => _NotifyHubScreenState();
}

class _NotifyHubScreenState extends State<NotifyHubScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> notices = [
    {
      'id': 'n1',
      'title': 'Exam Schedule Published',
      'description':
          'The final exam routine has been uploaded to the portal. Check your dashboard for details. Rooms and timing have been updated.',
      'date': '6 Nov 2025, 10:45 AM',
      'audience': 'Students',
    },
    {
      'id': 'n2',
      'title': 'Meeting Reminder',
      'description':
          'All teachers must attend today’s academic council meeting at 3:00 PM in Conference Hall 2. Please be on time.',
      'date': '5 Nov 2025, 8:30 AM',
      'audience': 'Teachers',
    },
    {
      'id': 'n3',
      'title': 'Server Maintenance',
      'description':
          'System will be down for maintenance from 12:00 AM to 2:00 AM. Please avoid submissions during that window.',
      'date': '4 Nov 2025, 11:00 PM',
      'audience': 'All Users',
    },
  ];

  void _deleteNotice(int index) {
    final notice = notices[index];

    showDialog(
      context: context,
      builder:
          (_) => CommonConfirmDialog(
            title: "Delete Notice?",
            message:
                "Are you sure you want to permanently delete '${notice['title']}'?",
            icon: CupertinoIcons.trash,
            iconColor: Colors.redAccent,
            confirmColor: Colors.redAccent,
            onConfirm: () {
              setState(() => notices.removeAt(index));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "Notice deleted successfully",
                    style: TextStyle(color: Colors.white),
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Notify Hub"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: notices.length,
          itemBuilder: (context, i) {
            final n = notices[i];
            return NotifyCard(
              title: n['title'] as String,
              description: n['description'] as String,
              date: n['date'] as String,
              audience: n['audience'] as String,
              onEdit: () => context.push('/edit-notice', extra: n),
              onDelete: () => _deleteNotice(i),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-notice'),
        backgroundColor: AppColors.primaryLight,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Notice",
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
