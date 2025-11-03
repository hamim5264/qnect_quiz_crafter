import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/manage_users/widgets/manage_user_background_painter.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import 'widgets/manage_user_header.dart';
import 'widgets/manage_user_search_bar.dart';
import 'widgets/manage_user_stat_cards.dart';
import 'widgets/manage_user_growth_card.dart';
import 'widgets/manage_user_filter_tabs.dart';
import 'widgets/manage_user_card.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  String selectedFilter = 'Teacher';

  final List<Map<String, String>> allUsers = [
    {
      'name': 'Mst. Hasna Hena',
      'email': 'hena.quizcrafter@gmail.com',
      'role': 'Teacher',
      'image': 'assets/images/admin/sample_teacher.png',
    },
    {
      'name': 'Mst. Shahina Akter',
      'email': 'shahina.quizcrafter@gmail.com',
      'role': 'Teacher',
      'image': 'assets/images/admin/sample_teacher2.png',
    },
    {
      'name': 'Tasnim Jui',
      'email': 'tasnim.quizcrafter@gmail.com',
      'role': 'Student',
      'image': 'assets/images/admin/sample_teacher3.png',
    },
    {
      'name': 'John Blocked',
      'email': 'blocked.user@gmail.com',
      'role': 'Blocked',
      'image': 'assets/images/admin/sample_teacher.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredUsers =
        allUsers.where((user) => user['role'] == selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          const ManageUserBackground(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ManageUserHeader(),
                  const SizedBox(height: 20),

                  const ManageUserSearchBar(),
                  const SizedBox(height: 20),

                  const ManageUserStatCards(),
                  const SizedBox(height: 16),

                  const ManageUserGrowthCard(),
                  const SizedBox(height: 20),

                  ManageUserFilterTabs(
                    selectedFilter: selectedFilter,
                    onFilterChanged: (value) {
                      setState(() => selectedFilter = value);
                    },
                  ),
                  const SizedBox(height: 20),

                  for (final user in filteredUsers)
                    ManageUserCard(
                      name: user['name']!,
                      email: user['email']!,
                      image: user['image']!,
                    ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
