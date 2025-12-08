// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
//
// class UserAchievementBadge {
//   final String name;
//   final String lottiePath;
//   final String role;
//   final int requiredXp;
//   final int requiredLevel;
//   final bool unlocked;
//
//   const UserAchievementBadge({
//     required this.name,
//     required this.lottiePath,
//     required this.role,
//     required this.requiredXp,
//     required this.requiredLevel,
//     required this.unlocked,
//   });
//
//   UserAchievementBadge copyWith({bool? unlocked}) {
//     return UserAchievementBadge(
//       name: name,
//       lottiePath: lottiePath,
//       role: role,
//       requiredXp: requiredXp,
//       requiredLevel: requiredLevel,
//       unlocked: unlocked ?? this.unlocked,
//     );
//   }
// }
//
// class UserAchievementsState {
//   final bool loading;
//   final String? error;
//
//   final int xp;
//   final int level;
//
//   final int totalQuizzes;
//   final int totalCourses;
//   final double monthlyGrowth;
//   final int specialCount;
//
//   final List<UserAchievementBadge> badges;
//   final Map<String, dynamic> unlockedMap;
//
//   const UserAchievementsState({
//     required this.loading,
//     required this.error,
//     required this.xp,
//     required this.level,
//     required this.totalQuizzes,
//     required this.totalCourses,
//     required this.monthlyGrowth,
//     required this.specialCount,
//     required this.badges,
//     required this.unlockedMap,
//   });
//
//   factory UserAchievementsState.initial() => const UserAchievementsState(
//     loading: true,
//     error: null,
//     xp: 0,
//     level: 1,
//     totalQuizzes: 0,
//     totalCourses: 0,
//     monthlyGrowth: 0.0,
//     specialCount: 0,
//     badges: [],
//     unlockedMap: {},
//   );
//
//   UserAchievementsState copyWith({
//     bool? loading,
//     String? error,
//     int? xp,
//     int? level,
//     int? totalQuizzes,
//     int? totalCourses,
//     double? monthlyGrowth,
//     int? specialCount,
//     List<UserAchievementBadge>? badges,
//     Map<String, dynamic>? unlockedMap,
//   }) {
//     return UserAchievementsState(
//       loading: loading ?? this.loading,
//       error: error,
//       xp: xp ?? this.xp,
//       level: level ?? this.level,
//       totalQuizzes: totalQuizzes ?? this.totalQuizzes,
//       totalCourses: totalCourses ?? this.totalCourses,
//       monthlyGrowth: monthlyGrowth ?? this.monthlyGrowth,
//       specialCount: specialCount ?? this.specialCount,
//       badges: badges ?? this.badges,
//       unlockedMap: unlockedMap ?? this.unlockedMap,
//     );
//   }
// }
//
// class UserAchievementsController
//     extends StateNotifier<UserAchievementsState> {
//   final FirebaseAuth _auth;
//   final FirebaseFirestore _firestore;
//   final String role;
//
//   UserAchievementsController(
//       this._auth, this._firestore, this.role)
//       : super(UserAchievementsState.initial()) {
//     _load();
//   }
//
//   Future<void> refresh() async => _load();
//
//   Future<void> _load() async {
//     try {
//       state = state.copyWith(loading: true, error: null);
//
//       final uid = _auth.currentUser?.uid;
//       if (uid == null) {
//         state = state.copyWith(loading: false, error: "Not logged in");
//         return;
//       }
//
//       final userDoc = await _firestore.collection('users').doc(uid).get();
//       if (!userDoc.exists) {
//         state = state.copyWith(loading: false, error: "User not found");
//         return;
//       }
//
//       final data = userDoc.data()!;
//       final xp = data['xp'] ?? 0;
//       final level = data['level'] ?? 1;
//
//       final unlockedMap = Map<String, dynamic>.from(
//         data['achievements'] ?? {},
//       );
//
//       final badges = _buildBadgeList(role, unlockedMap);
//
//       state = state.copyWith(
//         loading: false,
//         xp: xp,
//         level: level,
//         badges: badges,
//         unlockedMap: unlockedMap,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         loading: false,
//         error: e.toString(),
//       );
//     }
//   }
//
//   List<UserAchievementBadge> _buildBadgeList(
//       String role, Map<String, dynamic> unlockedMap) {
//     final isTeacher = role == "teacher";
//
//     final names = isTeacher
//         ? [
//       "Spark Crafter",
//       "Steady Guide",
//       "Quiz Coach",
//       "Concept Scholar",
//       "Master Crafter",
//       "Insight Maestro",
//       "Prime Mentor",
//       "Learning Luminary",
//       "Trailblazer Teacher",
//       "Legend Crafter",
//     ]
//         : [
//       "Spark Learner",
//       "Steady Striver",
//       "Quiz Challenger",
//       "Concept Builder",
//       "Skill Sprinter",
//       "Insight Achiever",
//       "Prime Performer",
//       "Learning Luminary",
//       "Trailblazer Student",
//       "Legend Scholar",
//     ];
//
//     List<UserAchievementBadge> list = [];
//
//     for (int i = 0; i < names.length; i++) {
//       final thresholds = _badgeThreshold(i);
//
//       list.add(
//         UserAchievementBadge(
//           name: names[i],
//           lottiePath: 'assets/badges/badge${i + 1}.json',
//           role: role,
//           requiredXp: thresholds.$1,
//           requiredLevel: thresholds.$2,
//           unlocked: unlockedMap[names[i]] == true,
//         ),
//       );
//     }
//
//     return list;
//   }
//
//   /// Same thresholds as before
//   (int, int) _badgeThreshold(int i) {
//     switch (i) {
//       case 0:
//         return (0, 1);
//       case 1:
//         return (200, 1);
//       case 2:
//         return (400, 1);
//       case 3:
//         return (700, 2);
//       case 4:
//         return (1000, 3);
//       case 5:
//         return (1500, 4);
//       case 6:
//         return (2200, 5);
//       case 7:
//         return (3000, 6);
//       case 8:
//         return (4000, 7);
//       case 9:
//         return (5200, 8);
//       default:
//         return (0, 1);
//     }
//   }
// }
//
// final userAchievementsControllerProvider =
// StateNotifierProvider.family<UserAchievementsController,
//     UserAchievementsState, String>((ref, role) {
//   return UserAchievementsController(
//     FirebaseAuth.instance,
//     FirebaseFirestore.instance,
//     role,
//   );
// });


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class UserAchievementBadge {
  final String name;
  final String lottiePath;
  final String role;
  final int requiredXp;
  final int requiredLevel;
  final bool unlocked;

  const UserAchievementBadge({
    required this.name,
    required this.lottiePath,
    required this.role,
    required this.requiredXp,
    required this.requiredLevel,
    required this.unlocked,
  });

  UserAchievementBadge copyWith({bool? unlocked}) {
    return UserAchievementBadge(
      name: name,
      lottiePath: lottiePath,
      role: role,
      requiredXp: requiredXp,
      requiredLevel: requiredLevel,
      unlocked: unlocked ?? this.unlocked,
    );
  }
}

class UserAchievementsState {
  final bool loading;
  final String? error;

  final int xp;
  final int level;

  final int totalQuizzes;
  final int totalCourses;
  final double monthlyGrowth;
  final int specialCount;

  final double sevenDayGrowth; // NEW FIELD

  final List<UserAchievementBadge> badges;
  final Map<String, dynamic> unlockedMap;

  const UserAchievementsState({
    required this.loading,
    required this.error,
    required this.xp,
    required this.level,
    required this.totalQuizzes,
    required this.totalCourses,
    required this.monthlyGrowth,
    required this.specialCount,
    required this.sevenDayGrowth,
    required this.badges,
    required this.unlockedMap,
  });

  factory UserAchievementsState.initial() => const UserAchievementsState(
    loading: true,
    error: null,
    xp: 0,
    level: 1,
    totalQuizzes: 0,
    totalCourses: 0,
    monthlyGrowth: 0.0,
    specialCount: 0,
    sevenDayGrowth: 0.0, // NEW
    badges: [],
    unlockedMap: {},
  );

  UserAchievementsState copyWith({
    bool? loading,
    String? error,
    int? xp,
    int? level,
    int? totalQuizzes,
    int? totalCourses,
    double? monthlyGrowth,
    int? specialCount,
    double? sevenDayGrowth,
    List<UserAchievementBadge>? badges,
    Map<String, dynamic>? unlockedMap,
  }) {
    return UserAchievementsState(
      loading: loading ?? this.loading,
      error: error,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
      totalCourses: totalCourses ?? this.totalCourses,
      monthlyGrowth: monthlyGrowth ?? this.monthlyGrowth,
      specialCount: specialCount ?? this.specialCount,
      sevenDayGrowth: sevenDayGrowth ?? this.sevenDayGrowth,
      badges: badges ?? this.badges,
      unlockedMap: unlockedMap ?? this.unlockedMap,
    );
  }
}

class UserAchievementsController
    extends StateNotifier<UserAchievementsState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final String role;

  UserAchievementsController(
      this._auth, this._firestore, this.role)
      : super(UserAchievementsState.initial()) {
    _load();
  }

  Future<void> refresh() async => _load();

  Future<void> _load() async {
    try {
      state = state.copyWith(loading: true, error: null);

      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        state = state.copyWith(loading: false, error: "Not logged in");
        return;
      }

      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (!userDoc.exists) {
        state = state.copyWith(loading: false, error: "User not found");
        return;
      }

      final data = userDoc.data()!;
      final xp = data['xp'] ?? 0;
      final level = data['level'] ?? 1;

      // -----------------------------
      // 7-DAY XP GROWTH CALCULATION
      // -----------------------------
      DateTime now = DateTime.now();
      DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));

      final xpLogsSnap = await _firestore
          .collection("users")
          .doc(uid)
          .collection("xp_logs")
          .where("date", isGreaterThanOrEqualTo: sevenDaysAgo)
          .get();

      int xpLast7Days = 0;

      for (var doc in xpLogsSnap.docs) {
        xpLast7Days += ((doc["xp"] ?? 0) as num).toInt();
      }

      double sevenDayGrowth = 0;
      if (xp > 0) {
        sevenDayGrowth = (xpLast7Days / xp) * 100;
      }

      // -----------------------------
      // BADGE UNLOCK MAP
      // -----------------------------
      final unlockedMap = Map<String, dynamic>.from(
        data['achievements'] ?? {},
      );

      final badges = _buildBadgeList(role, unlockedMap);

      state = state.copyWith(
        loading: false,
        xp: xp,
        level: level,
        badges: badges,
        unlockedMap: unlockedMap,
        sevenDayGrowth: sevenDayGrowth, // NEW
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  List<UserAchievementBadge> _buildBadgeList(
      String role, Map<String, dynamic> unlockedMap) {
    final isTeacher = role == "teacher";

    final names = isTeacher
        ? [
      "Spark Crafter",
      "Steady Guide",
      "Quiz Coach",
      "Concept Scholar",
      "Master Crafter",
      "Insight Maestro",
      "Prime Mentor",
      "Learning Luminary",
      "Trailblazer Teacher",
      "Legend Crafter",
    ]
        : [
      "Spark Learner",
      "Steady Striver",
      "Quiz Challenger",
      "Concept Builder",
      "Skill Sprinter",
      "Insight Achiever",
      "Prime Performer",
      "Learning Luminary",
      "Trailblazer Student",
      "Legend Scholar",
    ];

    List<UserAchievementBadge> list = [];

    for (int i = 0; i < names.length; i++) {
      final thresholds = _badgeThreshold(i);

      list.add(
        UserAchievementBadge(
          name: names[i],
          lottiePath: 'assets/badges/badge${i + 1}.json',
          role: role,
          requiredXp: thresholds.$1,
          requiredLevel: thresholds.$2,
          unlocked: unlockedMap[names[i]] == true,
        ),
      );
    }

    return list;
  }

  /// XP + Level thresholds
  (int, int) _badgeThreshold(int i) {
    switch (i) {
      case 0:
        return (0, 1);
      case 1:
        return (200, 1);
      case 2:
        return (400, 1);
      case 3:
        return (700, 2);
      case 4:
        return (1000, 3);
      case 5:
        return (1500, 4);
      case 6:
        return (2200, 5);
      case 7:
        return (3000, 6);
      case 8:
        return (4000, 7);
      case 9:
        return (5200, 8);
      default:
        return (0, 1);
    }
  }
}

final userAchievementsControllerProvider =
StateNotifierProvider.family<UserAchievementsController,
    UserAchievementsState, String>((ref, role) {
  return UserAchievementsController(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
    role,
  );
});
