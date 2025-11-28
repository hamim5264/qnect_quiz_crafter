import 'package:cloud_firestore/cloud_firestore.dart';

class AdminGrowthRepository {
  final FirebaseFirestore firestore;

  AdminGrowthRepository(this.firestore);

  Future<int> countUsersForMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    final snapshot =
        await firestore
            .collection('users')
            .where('createdAt', isGreaterThanOrEqualTo: start.toIso8601String())
            .where('createdAt', isLessThan: end.toIso8601String())
            .get();

    return snapshot.docs.length;
  }
}
