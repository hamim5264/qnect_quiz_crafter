import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserXpLevel {
  final int xp;
  final int level;
  final int xpPercent;
  final String levelText;
  final String xpText;

  const UserXpLevel({
    required this.xp,
    required this.level,
    required this.xpPercent,
    required this.levelText,
    required this.xpText,
  });
}

class XpService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  XpService(this._auth, this._firestore);

  int _int(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  Future<UserXpLevel?> calculateXpForUser(String uid) async {
    print("XP DEBUG ▶ Calculating XP for $uid");

    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (!userDoc.exists) {
      print("XP DEBUG ▶ User doc does not exist");
      return null;
    }

    final data = userDoc.data()!;
    final role = (data['role'] ?? 'student').toString().toLowerCase();
    final storedXp = _int(data['xp']);

    print("XP DEBUG ▶ User role = $role");
    print("XP DEBUG ▶ Stored XP in Firestore = $storedXp");

    int eventsXp = 0;

    if (role == 'teacher') {
      final coursesSnap =
          await _firestore
              .collection('courses')
              .where('teacherId', isEqualTo: uid)
              .get();

      int approved = 0;
      int quizzes = 0;
      int sold = 0;

      for (var doc in coursesSnap.docs) {
        final c = doc.data();

        quizzes += _int(c['quizCount']);
        sold += _int(c['sold']);

        if ((c['status'] ?? '').toString().toLowerCase() == 'approved') {
          approved++;
        }
      }

      eventsXp += coursesSnap.docs.length * 30;
      eventsXp += quizzes * 10;
      eventsXp += approved * 50;
      eventsXp += sold * 15;

      if (eventsXp > 0 && eventsXp < 100) {
        eventsXp = 100;
      }

      print("XP DEBUG ▶ Teacher courses=${coursesSnap.docs.length}");
      print(
        "XP DEBUG ▶ Teacher quizzes=$quizzes sold=$sold approved=$approved",
      );
      print("XP DEBUG ▶ Teacher events XP = $eventsXp");
    } else {
      final myCoursesSnap =
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('myCourses')
              .get();

      final enrolled = myCoursesSnap.docs.length;
      final enrolledXp = enrolled * 100;
      eventsXp += enrolledXp;

      print("XP DEBUG ▶ Student enrolled courses = $enrolled");
      print("XP DEBUG ▶ Enrolled XP = $enrolledXp");

      int finishedCourses = 0;
      for (var doc in myCoursesSnap.docs) {
        final c = doc.data();
        final totalQ = _int(c['totalQuizzes']);
        final doneQ = _int(c['completedQuizzes']);

        print("XP DEBUG ▶ myCourse totalQ=$totalQ doneQ=$doneQ");

        if (totalQ > 0 && doneQ >= totalQ) {
          finishedCourses++;
        }
      }

      final completedXp = finishedCourses * 100;
      eventsXp += completedXp;

      print("XP DEBUG ▶ Completed courses = $finishedCourses");
      print("XP DEBUG ▶ Completed XP = $completedXp");

      int totalPoints = 0;
      try {
        final attemptsSnap =
            await _firestore
                .collectionGroup('attempts')
                .where('userId', isEqualTo: uid)
                .get();

        print("XP DEBUG ▶ Total attempts = ${attemptsSnap.docs.length}");

        for (var doc in attemptsSnap.docs) {
          totalPoints += _int(doc['points']);
        }
      } catch (e) {
        print(
          "XP DEBUG ▶ Attempts blocked by rules or error: $e, using 0 points",
        );
      }

      final attemptXp = (totalPoints ~/ 10) * 20;
      eventsXp += attemptXp;

      print("XP DEBUG ▶ Points = $totalPoints");
      print("XP DEBUG ▶ Attempt XP = $attemptXp");
    }

    int xp = eventsXp;
    if (storedXp > xp) xp = storedXp;

    if (xp > 10000) xp = 10000;

    int level = (xp ~/ 1000) + 1;
    if (level > 10) level = 10;

    final levelMinXp = (level - 1) * 1000;
    int inLevelXp = xp - levelMinXp;
    if (inLevelXp < 0) inLevelXp = 0;
    if (inLevelXp > 1000) inLevelXp = 1000;

    final percent = ((inLevelXp / 1000) * 100).round();

    print("XP DEBUG ▶ FINAL EVENTS XP = $eventsXp");
    print("XP DEBUG ▶ FINAL STORED+EVENT XP = $xp");
    print("XP DEBUG ▶ FINAL LEVEL = $level");
    print("XP DEBUG ▶ IN-LEVEL XP = $inLevelXp");
    print("XP DEBUG ▶ PERCENT = $percent");

    await _firestore.collection('users').doc(uid).set({
      'xp': xp,
      'xpLevel': level,
    }, SetOptions(merge: true));

    print("XP DEBUG ▶ SAVED TO FIRESTORE SUCCESSFULLY!");

    return UserXpLevel(
      xp: xp,
      level: level,
      xpPercent: percent,
      levelText: "LEVEL ${level.toString().padLeft(2, '0')}",
      xpText: "XP $inLevelXp / 1000",
    );
  }
}

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final xpServiceProvider = Provider<XpService>((ref) {
  return XpService(FirebaseAuth.instance, FirebaseFirestore.instance);
});

final userXpProvider = FutureProvider<UserXpLevel?>((ref) async {
  final authState = ref.watch(authStateChangesProvider);

  final user = authState.value;
  if (user == null) {
    print("XP DEBUG ▶ userXpProvider → no user");
    return null;
  }

  final service = ref.watch(xpServiceProvider);
  return service.calculateXpForUser(user.uid);
});
