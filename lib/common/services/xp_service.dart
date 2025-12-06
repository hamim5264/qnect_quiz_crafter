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

  Future<UserXpLevel?> calculateCurrentUserXp() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) return null;

    final data = userDoc.data()!;
    final role = (data['role'] ?? 'student').toString().toLowerCase();

    int xp = _int(data['xp']);

    if (xp < 100) xp = 100;

    if (role == 'teacher') {
      final coursesSnap =
          await _firestore
              .collection('courses')
              .where('teacherId', isEqualTo: user.uid)
              .get();

      int approved = 0;
      int quizzes = 0;
      int sold = 0;

      for (var doc in coursesSnap.docs) {
        final c = doc.data();
        if ((c['status'] ?? '').toString().toLowerCase() == 'approved') {
          approved++;
        }
        quizzes += _int(c['quizCount']);
        sold += _int(c['sold']);
      }

      xp += coursesSnap.docs.length * 30;
      xp += quizzes * 10;
      xp += approved * 50;
      xp += sold * 15;
    } else {
      final myCoursesSnap =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('myCourses')
              .get();

      int enrolled = myCoursesSnap.docs.length;
      xp += enrolled * 100;

      int finishedCourses = 0;

      for (var doc in myCoursesSnap.docs) {
        final c = doc.data();
        final t = _int(c['totalQuizzes']);
        final d = _int(c['completedQuizzes']);

        if (t > 0 && d >= t) {
          finishedCourses++;
        }
      }

      xp += finishedCourses * 100;

      final attemptsSnap =
          await _firestore
              .collectionGroup('attempts')
              .where('userId', isEqualTo: user.uid)
              .get();

      int totalPoints = 0;

      for (var doc in attemptsSnap.docs) {
        totalPoints += _int(doc['points']);
      }

      int earnedXp = (totalPoints ~/ 10) * 20;
      xp += earnedXp;
    }

    if (xp > 10000) xp = 10000;

    int level = (xp ~/ 1000) + 1;
    if (level > 10) level = 10;

    int levelMin = (level - 1) * 1000;
    int inLevel = xp - levelMin;
    int percent = ((inLevel / 1000) * 100).round();

    final levelText = "LEVEL ${level.toString().padLeft(2, '0')}";
    final xpText = "XP $percent";

    await _firestore.collection('users').doc(user.uid).set({
      'xp': xp,
      'level': level,
    }, SetOptions(merge: true));

    return UserXpLevel(
      xp: xp,
      level: level,
      xpPercent: percent,
      levelText: levelText,
      xpText: xpText,
    );
  }
}

final xpServiceProvider = Provider<XpService>((ref) {
  return XpService(FirebaseAuth.instance, FirebaseFirestore.instance);
});

final userXpProvider = FutureProvider<UserXpLevel?>((ref) async {
  final service = ref.watch(xpServiceProvider);
  return service.calculateCurrentUserXp();
});
