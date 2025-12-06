import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
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
  String selectedGroup = "";
  String selectedLevel = "";
  String selectedCourse = "";

  bool loading = true;

  List<Map<String, dynamic>> leaderboardUsers = [];

  List<Map<String, dynamic>> availableCourses = [];

  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeFilters();
  }

  Future<void> _initializeFilters() async {
    loading = true;
    setState(() {});

    if (widget.userRole == "student") {
      await _setupStudentFilters();
    } else {
      await _setupAdminTeacherFilters();
    }

    loading = false;
    setState(() {});

    if (selectedCourse.isNotEmpty) {
      _loadLeaderboard();
    }
  }

  Future<void> _setupStudentFilters() async {
    final userDoc =
        await db.collection("users").doc(widget.currentUserId).get();
    final data = userDoc.data() ?? {};

    selectedGroup = (data["group"] ?? "").toString();
    selectedLevel = (data["level"] ?? "").toString();

    final myCoursesSnap =
        await db
            .collection("users")
            .doc(widget.currentUserId)
            .collection("myCourses")
            .get();

    availableCourses.clear();

    for (var d in myCoursesSnap.docs) {
      final courseId = d.id;

      final courseDoc = await db.collection("courses").doc(courseId).get();

      if (!courseDoc.exists) continue;

      final courseData = courseDoc.data() ?? {};
      availableCourses.add({
        "id": courseId,
        "title": (courseData["title"] ?? "Unknown Course").toString(),
      });
    }

    if (availableCourses.isNotEmpty) {
      selectedCourse = (availableCourses.first["id"] ?? "").toString();
    }
  }

  Future<void> _setupAdminTeacherFilters() async {
    selectedGroup = "HSC";
    selectedLevel = "Science";
    await _loadCoursesForFilter();
  }

  Future<void> _loadCoursesForFilter() async {
    final snap =
        await db
            .collection("courses")
            .where("status", isEqualTo: "Approved")
            .where("group", isEqualTo: selectedGroup)
            .where("level", isEqualTo: selectedLevel)
            .get();

    availableCourses =
        snap.docs
            .map((d) => {"id": d.id, "title": d["title"] ?? "Unknown Course"})
            .toList();

    if (availableCourses.isNotEmpty) {
      selectedCourse = availableCourses.first["id"];
    } else {
      selectedCourse = "";
    }
  }

  Future<void> _loadLeaderboard() async {
    if (selectedCourse.isEmpty) {
      leaderboardUsers.clear();
      setState(() {});
      return;
    }

    loading = true;
    setState(() {});

    leaderboardUsers.clear();

    try {
      final usersSnap = await db.collection("users").get();

      for (var userDoc in usersSnap.docs) {
        final uid = userDoc.id;
        final userData = userDoc.data();

        final myCourseDoc =
            await db
                .collection("users")
                .doc(uid)
                .collection("myCourses")
                .doc(selectedCourse)
                .get();

        if (!myCourseDoc.exists) continue;

        int totalPoints = 0;

        final courseData = myCourseDoc.data() ?? {};
        courseData.forEach((key, value) {
          if (key.startsWith("earnedPoints_") && value is int) {
            totalPoints += value;
          }
        });

        final firstName = (userData["firstName"] ?? "").toString();
        final lastName = (userData["lastName"] ?? "").toString();
        final email = (userData["email"] ?? "").toString();
        final profileImage = (userData["profileImage"] ?? "").toString();

        leaderboardUsers.add({
          "id": uid,
          "name":
              "$firstName $lastName".trim().isEmpty
                  ? "User"
                  : "$firstName $lastName".trim(),
          "email": email,
          "image": profileImage,
          "points": totalPoints,
        });
      }

      leaderboardUsers.sort((a, b) => b["points"].compareTo(a["points"]));

      for (int i = 0; i < leaderboardUsers.length; i++) {
        leaderboardUsers[i]["rank"] = i + 1;
      }
    } catch (e) {
      debugPrint("Leaderboard load error: $e");
    }

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Leaderboard"),
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
                availableCourses: availableCourses,
                onGroupChanged: (v) async {
                  selectedGroup = v;
                  await _loadCoursesForFilter();
                  setState(() {});
                  _loadLeaderboard();
                },
                onLevelChanged: (v) async {
                  selectedLevel = v;
                  await _loadCoursesForFilter();
                  setState(() {});
                  _loadLeaderboard();
                },
                onCourseChanged: (v) {
                  selectedCourse = v;
                  setState(() {});
                  _loadLeaderboard();
                },
              ),

              const SizedBox(height: 16),

              Expanded(
                child:
                    loading
                        ? const Center(child: AppLoader())
                        : ListView.builder(
                          itemCount: leaderboardUsers.length,
                          itemBuilder: (context, i) {
                            final u = leaderboardUsers[i];
                            final bool isYou = u["id"] == widget.currentUserId;

                            return LeaderboardUserCard(
                              name: isYou ? "You" : (u["name"] ?? ""),
                              email: u["email"] ?? "",
                              image: u["image"] ?? "",
                              rank: u["rank"] ?? 0,
                              points: u["points"] ?? 0,
                              level: 0,
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
