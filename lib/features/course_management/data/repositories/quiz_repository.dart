import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';

class QuizRepository {
  final FirebaseFirestore _db;

  QuizRepository(this._db);

  CollectionReference get _quizzes => _db.collection('quizzes');

  CollectionReference _questions(String quizId) =>
      _quizzes.doc(quizId).collection('questions');

  Stream<List<QuizModel>> watchQuizzesForCourse(String courseId) {
    return _quizzes
        .where('courseId', isEqualTo: courseId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => QuizModel.fromDoc(d)).toList());
  }

  Future<String> createQuiz(QuizModel quiz) async {
    final now = DateTime.now();
    final doc = await _quizzes.add(
      quiz.copyWith(createdAt: now, updatedAt: now).toJson(),
    );
    return doc.id;
  }

  Future<void> updateQuiz(QuizModel quiz) async {
    await _quizzes
        .doc(quiz.id)
        .update(quiz.copyWith(updatedAt: DateTime.now()).toJson());
  }

  Future<void> deleteQuiz(String quizId) async {
    await _quizzes.doc(quizId).delete();
  }

  Future<void> setQuestions({
    required String quizId,
    required List<QuestionModel> questions,
  }) async {
    final batch = _db.batch();
    final col = _questions(quizId);

    final existing = await col.get();
    for (final d in existing.docs) {
      batch.delete(d.reference);
    }

    for (final q in questions) {
      final ref = col.doc();
      batch.set(ref, q.copyWith(id: ref.id).toJson());
    }

    batch.update(_quizzes.doc(quizId), {
      'totalQuestions': questions.length,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }
}
