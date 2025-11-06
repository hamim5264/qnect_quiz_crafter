import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../common/widgets/action_feedback_dialog.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import 'widgets/message_filter_bar.dart';
import 'widgets/message_search_bar.dart';
import 'widgets/message_card.dart';

class MessageScreen extends StatefulWidget {
  final String role;

  const MessageScreen({super.key, required this.role});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String selectedFilter = 'All';

  List<Map<String, dynamic>> messages = [
    {
      'name': 'Megha',
      'msg': 'Keep going, you’re improving!',
      'time': '04:26 PM',
      'avatar': 'assets/images/admin/sample_teacher2.png',
      'isActive': true,
      'isRead': false,
      'role': 'teacher',
    },
    {
      'name': 'Hamim',
      'msg': 'Check leaderboard now!',
      'time': '10:34 PM',
      'avatar': 'assets/images/admin/sample_teacher.png',
      'isActive': false,
      'isRead': true,
      'role': 'admin',
    },
    {
      'name': 'Rabia',
      'msg': 'Well done on your last quiz!',
      'time': '09:15 AM',
      'avatar': 'assets/images/admin/sample_teacher3.png',
      'isActive': true,
      'isRead': true,
      'role': 'student',
    },
  ];

  void _deleteMessage(int index) {
    showDialog(
      context: context,
      builder:
          (_) => ActionFeedbackDialog(
            icon: CupertinoIcons.trash,
            title: 'Delete Message?',
            subtitle: 'Are you sure you want to delete this conversation?',
            buttonText: 'Confirm Delete',
            onPressed: () {
              Navigator.pop(context);
              setState(() => messages.removeAt(index));
            },
          ),
    );
  }

  List<Map<String, dynamic>> get filteredMessages {
    if (selectedFilter == 'All') return messages;
    return messages
        .where((m) => m['role'] == selectedFilter.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final showRoles =
        widget.role == 'admin'
            ? ['Teacher', 'Student']
            : ['Admin', 'Teacher', 'Student'];

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Messages'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const MessageSearchBar(),
              const SizedBox(height: 14),
              MessageFilterBar(
                filters: showRoles,
                selected: selectedFilter,
                onSelected: (v) => setState(() => selectedFilter = v),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredMessages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = filteredMessages[index];
                    return Dismissible(
                      key: ValueKey(item['name']),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          CupertinoIcons.trash,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (_) async {
                        _deleteMessage(index);
                        return false;
                      },
                      child: MessageCard(
                        name: item['name'],
                        message: item['msg'],
                        time: item['time'],
                        avatar: item['avatar'],
                        isActive: item['isActive'],
                        isRead: item['isRead'],
                      ),
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
