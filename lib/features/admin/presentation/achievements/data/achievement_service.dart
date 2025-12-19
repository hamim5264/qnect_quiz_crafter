import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final teacherBadges = const {
    "Spark Crafter": 1,
    "Steady Guide": 2,
    "Quiz Coach": 3,
    "Concept Scholar": 4,
    "Master Crafter": 5,
    "Insight Maestro": 6,
    "Prime Mentor": 7,
    "Learning Luminary": 8,
    "Trailblazer Teacher": 9,
    "Legend Crafter": 10,
  };

  final studentBadges = const {
    "Spark Learner": 1,
    "Steady Striver": 2,
    "Quiz Challenger": 3,
    "Concept Builder": 4,
    "Skill Sprinter": 5,
    "Insight Achiever": 6,
    "Prime Performer": 7,
    "Learning Luminary": 8,
    "Trailblazer Student": 9,
    "Legend Scholar": 10,
  };

  Future<List<Map<String, dynamic>>> getEligibleUsers(String role) async {
    final snapshot =
        await _firestore
            .collection("users")
            .where("role", isEqualTo: role.toLowerCase())
            .get();

    return snapshot.docs
        .map(
          (d) => {
            "uid": d.id,
            "name": d["username"],
            "level": d["level"],
            "achievements": d.data()["achievements"] ?? {},
          },
        )
        .toList();
  }

  List<String> getUnlockableBadges({
    required String role,
    required int level,
    required Map achievements,
  }) {
    final badgeMap = role == "Teacher" ? teacherBadges : studentBadges;

    return badgeMap.entries
        .where(
          (entry) => level >= entry.value && (achievements[entry.key] != true),
        )
        .map((e) => e.key)
        .toList();
  }

  Future<void> unlockBadge({
    required String uid,
    required String badgeName,
  }) async {
    await _firestore.collection("users").doc(uid).set({
      "achievements": {badgeName: true},
    }, SetOptions(merge: true));
  }
}
