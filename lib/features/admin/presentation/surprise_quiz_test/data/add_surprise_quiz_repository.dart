import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/surprise_quiz_test/data/add_surprise_quiz_model.dart';

class SurpriseQuizListItem {
  final String id;
  final String title;
  final String description;
  final int durationSeconds;
  final int visibilityHours;
  final int points;
  final String group;
  final String level;
  final bool published;
  final Timestamp? createdAt;
  final Timestamp? publishedAt;

  SurpriseQuizListItem({
    required this.id,
    required this.title,
    required this.description,
    required this.durationSeconds,
    required this.visibilityHours,
    required this.points,
    required this.group,
    required this.level,
    required this.published,
    required this.createdAt,
    required this.publishedAt,
  });

  factory SurpriseQuizListItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return SurpriseQuizListItem(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      durationSeconds: (data['durationSeconds'] ?? 0) as int,
      visibilityHours: (data['visibilityHours'] ?? 0) as int,
      points: (data['points'] ?? 0) as int,
      group: data['group'] ?? '',
      level: data['level'] ?? '',
      published: (data['published'] ?? false) as bool,
      createdAt: data['createdAt'] as Timestamp?,
      publishedAt: data['publishedAt'] as Timestamp?,
    );
  }
}

class SurpriseQuizRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<SurpriseQuizQuestion>> import20RandomFromVault({
    required String group,
    required String level,
  }) async {
    final coursesSnap =
        await _db
            .collection('qcVaultCourses')
            .where('group', isEqualTo: group)
            .where('level', whereIn: [level, 'All'])
            .get();

    List<String> courseIds = coursesSnap.docs.map((e) => e.id).toList();
    List<SurpriseQuizQuestion> all = [];

    for (final cId in courseIds) {
      final qSnap = await _db.collection('qcVaultCourses/$cId/questions').get();

      for (final d in qSnap.docs) {
        final data = d.data();
        all.add(
          SurpriseQuizQuestion(
            question: data['question'] ?? '',
            options: Map<String, String>.from(data['options'] ?? {}),
            correct: data['correctOption'] ?? 'A',
            explanation: data['explanation'] ?? '',
          ),
        );
      }
    }

    all.shuffle(Random());
    return all.take(20).toList();
  }

  Future<void> saveQuiz({
    required String title,
    required String description,
    required Duration duration,
    required int visibilityHours,
    required int points,
    required String group,
    required String level,
    required String createdBy,
    required List<SurpriseQuizQuestion> questions,
  }) async {
    final doc = _db.collection('surpriseQuizzes').doc();

    await doc.set({
      "title": title,
      "description": description,
      "durationSeconds": duration.inSeconds,
      "visibilityHours": visibilityHours,
      "points": points,
      "group": group,
      "level": level,
      "createdAt": FieldValue.serverTimestamp(),
      "createdBy": createdBy,
      "published": false,
      "publishedAt": null,
      "questions": questions.map((e) => e.toMap()).toList(),
    });
  }

  Stream<List<SurpriseQuizListItem>> watchQuizzes({required bool published}) {
    return _db
        .collection('surpriseQuizzes')
        .where('published', isEqualTo: published)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => SurpriseQuizListItem.fromDoc(d)).toList(),
        );
  }

  Future<void> publishQuiz(String quizId) async {
    final doc = _db.collection('surpriseQuizzes').doc(quizId);
    await doc.update({
      'published': true,
      'publishedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteQuiz(String quizId) async {
    await _db.collection('surpriseQuizzes').doc(quizId).delete();
  }
}
