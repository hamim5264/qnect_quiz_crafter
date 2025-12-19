import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/notify_hub/data/notice_service.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/notify_hub/widgets/notify_card.dart';

import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../ui/design_system/tokens/colors.dart';

class NoticeFeedScreen extends StatelessWidget {
  final String role;

  const NoticeFeedScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Notices"),
      body: StreamBuilder(
        stream: NoticeService().audienceNotices(role),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CupertinoActivityIndicator());
          }

          final docs = snap.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.archivebox,
                    size: 48,
                    color: Colors.white70,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "No notices available",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i].data() as Map<String, dynamic>;
              return NotifyCard(
                title: d['title'],
                description: d['description'],
                date: d['createdAt']?.toDate().toString() ?? '',
                audience: d['audience'],
                onEdit: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "You cant edit notices",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                },
                onDelete: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "You cant delete notices",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
