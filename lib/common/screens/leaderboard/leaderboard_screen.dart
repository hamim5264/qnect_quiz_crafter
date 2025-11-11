import 'package:flutter/material.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import 'widgets/leaderboard_filter_card.dart';
import 'widgets/leaderboard_user_card.dart';

class LeaderboardScreen extends StatefulWidget {
  final String userRole;
  final String currentUserId;

  const LeaderboardScreen({
    super.key,
    required this.userRole,
    required this.currentUserId,
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String selectedGroup = "HSC";
  String selectedLevel = "Science";
  String selectedCourse = "Finance";

  final List<Map<String, dynamic>> users = [
    {
      "id": "u1",
      "name": "Megha",
      "email": "megha258@crafter.edu.bd",
      "level": 12,
      "points": 2456,
      "rank": 1,
      "image": "assets/images/dummy_user_avatar/dummy_user_1.png",
    },
    {
      "id": "u2",
      "name": "Leon",
      "email": "leon10nov@crafter.edu.bd",
      "level": 11,
      "points": 2156,
      "rank": 2,
      "image": "assets/images/dummy_user_avatar/dummy_user_2.png",
    },
    {
      "id": "u3",
      "name": "Rabia",
      "email": "rabia894@crafter.edu.bd",
      "level": 8,
      "points": 1456,
      "rank": 3,
      "image": "assets/images/dummy_user_avatar/dummy_user_3.png",
    },
    {
      "id": "u4",
      "name": "Tasnim",
      "email": "tasnim49@crafter.edu.bd",
      "level": 5,
      "points": 1156,
      "rank": 4,
      "image": "assets/images/dummy_user_avatar/dummy_user_4.png",
    },
    {
      "id": "u5",
      "name": "Rafi",
      "email": "rafi894@crafter.edu.bd",
      "level": 2,
      "points": 456,
      "rank": 5,
      "image": "assets/images/dummy_user_avatar/dummy_user_5.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Leaderboard'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              LeaderboardFilterCard(
                userRole: widget.userRole,
                selectedGroup: selectedGroup,
                selectedLevel: selectedLevel,
                selectedCourse: selectedCourse,
                onGroupChanged: (v) => setState(() => selectedGroup = v),
                onLevelChanged: (v) => setState(() => selectedLevel = v),
                onCourseChanged: (v) => setState(() => selectedCourse = v),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final isYou = user["id"] == widget.currentUserId;
                    return LeaderboardUserCard(
                      name: isYou ? "You" : user["name"],
                      email: user["email"],
                      level: user["level"],
                      points: user["points"],
                      rank: user["rank"],
                      image: user["image"],
                      highlight: isYou && widget.userRole == "student",
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
