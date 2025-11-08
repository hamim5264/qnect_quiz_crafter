import 'package:flutter/material.dart';
import '../../../../../common/widgets/action_feedback_dialog.dart';
import '../../../../../common/widgets/common_item_filter.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import 'user_list_dialog.dart';

class UnlockBadgeCard extends StatefulWidget {
  const UnlockBadgeCard({super.key});

  @override
  State<UnlockBadgeCard> createState() => _UnlockBadgeCardState();
}

class _UnlockBadgeCardState extends State<UnlockBadgeCard> {
  String selectedRole = "Teacher";
  String? selectedUser;
  String? selectedBadge;

  final List<String> teacherBadges = [
    'Spark Crafter',
    'Steady Guide',
    'Quiz Coach',
    'Concept Scholar',
    'Master Crafter',
    'Insight Maestro',
    'Prime Mentor',
    'Learning Luminary',
    'Trailblazer Teacher',
    'Legend Crafter',
  ];

  final List<String> studentBadges = [
    'Spark Learner',
    'Steady Striver',
    'Quiz Challenger',
    'Concept Builder',
    'Skill Sprinter',
    'Insight Achiever',
    'Prime Performer',
    'Learning Luminary',
    'Trailblazer Student',
    'Legend Scholar',
  ];

  void _showUserSelectDialog() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => UserListDialog(role: selectedRole),
    );

    if (name != null) {
      setState(() {
        selectedUser = name;
        final currentList =
            selectedRole == "Teacher" ? teacherBadges : studentBadges;
        selectedBadge =
            currentList.contains(selectedBadge)
                ? selectedBadge
                : currentList.first;
      });
    }
  }

  void _unlockBadge() {
    showDialog(
      context: context,
      builder:
          (_) => ActionFeedbackDialog(
            icon: Icons.check_circle_outline,
            title: "Badge Unlocked!",
            subtitle:
                "The badge '${selectedBadge ?? ''}' has been successfully unlocked for ${selectedUser ?? 'the user'}.",
            buttonText: "OK",
            onPressed: () => Navigator.pop(context),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final badgeList = selectedRole == "Teacher" ? teacherBadges : studentBadges;

    if (selectedBadge != null && !badgeList.contains(selectedBadge)) {
      selectedBadge = null;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Unlock Badge",
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),

          CommonItemFilter(
            options: const ['Student', 'Teacher'],
            selected: selectedRole,
            onSelected:
                (v) => setState(() {
                  selectedRole = v;
                  final newList =
                      selectedRole == "Teacher" ? teacherBadges : studentBadges;
                  if (selectedBadge == null ||
                      !newList.contains(selectedBadge)) {
                    selectedBadge = null;
                  }
                }),
          ),
          const SizedBox(height: 16),

          TextField(
            readOnly: true,
            controller: TextEditingController(text: selectedUser ?? ''),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              labelText: "Select User",
              labelStyle: const TextStyle(color: Colors.white70),
              suffixIcon: IconButton(
                icon: const Icon(Icons.person_search, color: Colors.white70),
                onPressed: _showUserSelectDialog,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            dropdownColor: AppColors.primaryLight,
            iconEnabledColor: Colors.white,
            decoration: InputDecoration(
              labelText: "Select Badge",
              labelStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            value: selectedBadge,
            items:
                badgeList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: AppTypography.family,
                          ),
                        ),
                      ),
                    )
                    .toList(),
            onChanged: (v) => setState(() => selectedBadge = v),
          ),

          const SizedBox(height: 20),

          Center(
            child: ElevatedButton(
              onPressed:
                  (selectedUser != null && selectedBadge != null)
                      ? _unlockBadge
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Unlock Badge",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
