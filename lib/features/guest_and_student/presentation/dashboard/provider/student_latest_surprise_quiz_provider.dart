import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentSurpriseQuizPreview {
  final String id;
  final String title;
  final DateTime publishedAt;
  final int visibilityHours;

  StudentSurpriseQuizPreview({
    required this.id,
    required this.title,
    required this.publishedAt,
    required this.visibilityHours,
  });

  Duration get remainingTime {
    final endTime = publishedAt.add(Duration(hours: visibilityHours));
    return endTime.difference(DateTime.now());
  }

  bool get isExpired => remainingTime.isNegative;
}

final studentLatestSurpriseQuizProvider =
    FutureProvider<StudentSurpriseQuizPreview?>((ref) async {
      final snap =
          await FirebaseFirestore.instance
              .collection('surpriseQuizzes')
              .where('published', isEqualTo: true)
              .orderBy('publishedAt', descending: true)
              .limit(1)
              .get();

      if (snap.docs.isEmpty) return null;

      final doc = snap.docs.first;
      final data = doc.data();

      return StudentSurpriseQuizPreview(
        id: doc.id,
        title: data['title'] ?? 'Surprise Quiz',
        publishedAt: (data['publishedAt'] as Timestamp).toDate(),
        visibilityHours: data['visibilityHours'] ?? 24,
      );
    });
