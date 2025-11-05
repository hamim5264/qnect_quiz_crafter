import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../common/widgets/action_feedback_dialog.dart';
import 'widgets/feedback_search_bar.dart';
import 'widgets/feedback_count_box.dart';
import 'widgets/feedback_card.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final List<Map<String, dynamic>> feedbackList = [
    {
      'name': 'John Doe',
      'stars': 4,
      'teacher': 'Arpita Ghose Tushi',
      'course': 'English II',
      'comment':
          'All courses are perfectly aligned and teachers learning system is very well. Recommended this app for new learners.',
      'avg': 3.7,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Course Feedback'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FeedbackSearchBar(),
              const SizedBox(height: 14),
              const FeedbackCountBox(total: 219),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: feedbackList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = feedbackList[index];
                    return FeedbackCard(
                      name: item['name'],
                      stars: item['stars'],
                      teacher: item['teacher'],
                      course: item['course'],
                      comment: item['comment'],
                      average: item['avg'],
                      onDelete: () => _showDeleteDialog(context),
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

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => ActionFeedbackDialog(
            icon: CupertinoIcons.delete,
            title: 'Delete Feedback?',
            subtitle:
                'Are you sure you want to delete this feedback permanently?',
            buttonText: 'Confirm Delete',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Feedback deleted successfully')),
              );
            },
          ),
    );
  }
}
