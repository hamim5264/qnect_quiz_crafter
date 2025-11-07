import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../common/widgets/action_feedback_dialog.dart';

class AddNoticeScreen extends StatefulWidget {
  const AddNoticeScreen({super.key});

  @override
  State<AddNoticeScreen> createState() => _AddNoticeScreenState();
}

class _AddNoticeScreenState extends State<AddNoticeScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String audience = "All";

  void _sendNotice() {
    if (_titleController.text.trim().isEmpty ||
        _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    showDialog(
      context: context,
      builder:
          (_) => ActionFeedbackDialog(
            icon: Icons.check_circle_outline,
            title: "Notice Sent",
            subtitle:
                "Your notice has been successfully sent to $audience users.",
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
      appBar: const CommonRoundedAppBar(title: "Add Notice"),
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
                  onPressed: _sendNotice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Icon(
                    CupertinoIcons.location_fill,
                    color: AppColors.primaryDark,
                    size: 24,
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
