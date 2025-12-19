import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/notify_hub/data/notice_service.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import 'widgets/notify_card.dart';

class NotifyHubScreen extends StatefulWidget {
  const NotifyHubScreen({super.key});

  @override
  State<NotifyHubScreen> createState() => _NotifyHubScreenState();
}

class _NotifyHubScreenState extends State<NotifyHubScreen> {
  void _deleteNotice(String id) async {
    await NoticeService().deleteNotice(id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Notice deleted", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Notify Hub"),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: NoticeService().adminNotices(),
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
                      "No notices yet",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, i) {
                final n = docs[i];
                final data = n.data() as Map<String, dynamic>;

                return NotifyCard(
                  title: data['title'],
                  description: data['description'],
                  date:
                      data['createdAt'] == null
                          ? ''
                          : data['createdAt'].toDate().toString(),
                  audience: data['audience'],
                  onEdit:
                      () => context.push(
                        '/edit-notice',
                        extra: {...data, 'id': n.id},
                      ),
                  onDelete: () => _deleteNotice(n.id),
                );
              },
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('addNotice'),

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
