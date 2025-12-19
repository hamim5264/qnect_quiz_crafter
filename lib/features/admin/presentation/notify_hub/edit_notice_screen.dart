import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/notify_hub/data/notice_service.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../../../../../common/widgets/action_feedback_dialog.dart';

class EditNoticeScreen extends StatefulWidget {
  final Map<String, dynamic> notice;

  const EditNoticeScreen({super.key, required this.notice});

  @override
  State<EditNoticeScreen> createState() => _EditNoticeScreenState();
}

class _EditNoticeScreenState extends State<EditNoticeScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String audience;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.notice['title'] ?? '',
    );
    _descController = TextEditingController(
      text: widget.notice['description'] ?? '',
    );

    final rawAudience = widget.notice['audience'] ?? "All";
    if (rawAudience == "All Users") {
      audience = "All";
    } else if (rawAudience == "Students") {
      audience = "Students";
    } else if (rawAudience == "Teachers") {
      audience = "Teachers";
    } else {
      audience = "All";
    }
  }

  void _updateNotice() async {
    if (_titleController.text.trim().isEmpty ||
        _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    await NoticeService().updateNotice(
      widget.notice['id'],
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      audience: audience,
    );

    showDialog(
      context: context,
      builder:
          (_) => ActionFeedbackDialog(
            icon: Icons.check_circle_outline,
            title: "Notice Updated",
            subtitle: "Notice updated successfully.",
            buttonText: "OK",
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Edit Notice"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                cursorColor: AppColors.secondaryDark,
                textInputAction: TextInputAction.next,
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  filled: false,
                  fillColor: Colors.transparent,
                  labelText: 'Notice Title',
                  labelStyle: TextStyle(color: AppColors.secondaryDark),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryDark),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryLight),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                cursorColor: AppColors.secondaryDark,
                textInputAction: TextInputAction.next,
                controller: _descController,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  filled: false,
                  fillColor: Colors.transparent,
                  labelText: 'Description',
                  labelStyle: TextStyle(color: AppColors.secondaryDark),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryDark),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryLight),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              DropdownButtonFormField<String>(
                value: audience,
                dropdownColor: AppColors.primaryLight,
                decoration: const InputDecoration(
                  filled: false,
                  fillColor: Colors.transparent,
                  labelText: 'Select Audience',
                  labelStyle: TextStyle(color: AppColors.secondaryDark),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryDark),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All Users')),
                  DropdownMenuItem(value: 'Students', child: Text('Students')),
                  DropdownMenuItem(value: 'Teachers', child: Text('Teachers')),
                ],
                onChanged: (v) => setState(() => audience = v ?? 'All'),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateNotice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    "Update Notice",
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
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
