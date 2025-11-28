import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/month_stats_model.dart';

final monthlyGrowthProvider = FutureProvider.family<MonthStats, DateTime>((
  ref,
  date,
) async {
  final firestore = FirebaseFirestore.instance;

  final DateTime prevDate = DateTime(date.year, date.month - 1);

  int currentCount = 0;
  int previousCount = 0;

  final currentSnap =
      await firestore
          .collection("users")
          .where(
            "createdAt",
            isGreaterThanOrEqualTo: DateTime(date.year, date.month, 1),
          )
          .where(
            "createdAt",
            isLessThan: DateTime(date.year, date.month + 1, 1),
          )
          .get();

  currentCount = currentSnap.docs.length;

  final prevSnap =
      await firestore
          .collection("users")
          .where(
            "createdAt",
            isGreaterThanOrEqualTo: DateTime(prevDate.year, prevDate.month, 1),
          )
          .where(
            "createdAt",
            isLessThan: DateTime(prevDate.year, prevDate.month + 1, 1),
          )
          .get();

  previousCount = prevSnap.docs.length;

  return MonthStats(current: currentCount, previous: previousCount);
});
