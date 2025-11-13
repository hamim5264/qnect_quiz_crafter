import 'package:cloud_firestore/cloud_firestore.dart';
import 'qc_vault_models.dart';

class QCVaultRepository {
  final FirebaseFirestore _db;

  QCVaultRepository(this._db);

  CollectionReference get _coursesCol => _db.collection('qcVaultCourses');

  DocumentReference courseDoc(String courseId) => _coursesCol.doc(courseId);

  CollectionReference questionsCol(String courseId) =>
      courseDoc(courseId).collection('questions');

  Stream<List<QCVaultCourse>> watchCourses({
    required String group,
    required String level,
  }) {
    return _coursesCol
        .where('group', isEqualTo: group)
        .where('level', whereIn: [level, 'All'])
        .orderBy('title')
        .snapshots()
        .map((snap) => snap.docs.map((d) => QCVaultCourse.fromDoc(d)).toList());
  }

  Stream<List<QCVaultQuestion>> watchQuestions(String courseId) {
    return questionsCol(courseId)
        .orderBy('index')
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => QCVaultQuestion.fromDoc(d)).toList(),
        );
  }

  Future<void> addQuestion({
    required String courseId,
    required String question,
    required Map<String, String> options,
    required String correctOption,
    required String explanation,
  }) async {
    final normalizedQuestion = question.trim().toLowerCase();

    final dupSnap =
        await questionsCol(
          courseId,
        ).where('question', isEqualTo: normalizedQuestion).limit(1).get();

    if (dupSnap.docs.isNotEmpty) {
      throw Exception('This question already exists in this course.');
    }

    final normalizedOptions = options.map(
      (k, v) => MapEntry(k, v.trim().toLowerCase()),
    );

    final courseRef = courseDoc(courseId);
    final qCol = questionsCol(courseId);

    final lastSnap =
        await qCol.orderBy('index', descending: true).limit(1).get();

    final nextIndex =
        lastSnap.docs.isEmpty
            ? 1
            : (((lastSnap.docs.first.data()
                            as Map<String, dynamic>?)?['index'] ??
                        0)
                    as int) +
                1;

    await qCol.doc('q_$nextIndex').set({
      'index': nextIndex,
      'question': normalizedQuestion,
      'options': normalizedOptions,
      'correctOption': correctOption,
      'explanation': explanation.trim(),
    });

    await courseRef.update({'totalQuestions': FieldValue.increment(1)});
  }
}
