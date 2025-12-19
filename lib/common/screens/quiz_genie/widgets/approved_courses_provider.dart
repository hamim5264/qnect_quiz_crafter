import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/teacher/presentation/teacher_dashboard/widgets/teacher_explore_paid_courses.dart';

final approvedCoursesProvider = FutureProvider<List<CourseItem>>((ref) async {
  try {
    final snap =
        await FirebaseFirestore.instance
            .collection('courses')
            .where('status', isEqualTo: 'Approved')
            .limit(4)
            .get();

    debugPrint('📦 Approved courses count = ${snap.docs.length}');

    return snap.docs.map((doc) {
      final d = doc.data();

      debugPrint('➡️ Course: ${d['title']} | status=${d['status']}');

      return CourseItem(
        title: d['title'] ?? '',

        image:
            d['iconPath'] ??
            'https://i.ibb.co.com/r5ZxKXX/placeholder-course.png',

        quizCount: (d['quizCount'] as num?)?.toInt() ?? 0,

        enrolled: (d['enrolledCount'] as num?)?.toInt() ?? 0,

        price: (d['price'] as num?)?.toInt() ?? 0,

        discount: (d['discountPercent'] as num?)?.toInt() ?? 0,
      );
    }).toList();
  } catch (e, s) {
    debugPrint('❌ approvedCoursesProvider ERROR: $e');
    debugPrintStack(stackTrace: s);
    rethrow;
  }
});
