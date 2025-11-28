import 'package:cloud_firestore/cloud_firestore.dart';

class UserListRepository {
  final FirebaseFirestore firestore;

  UserListRepository(this.firestore);

  Future<List<Map<String, dynamic>>> getTeachers() async {
    final snap =
        await firestore
            .collection("users")
            .where("role", isEqualTo: "teacher")
            .get();

    return snap.docs.map((d) => d.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    final snap =
        await firestore
            .collection("users")
            .where("role", isEqualTo: "student")
            .get();

    return snap.docs.map((d) => d.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getBlockedUsers() async {
    final snap =
        await firestore
            .collection("users")
            .where("accountStatus", isEqualTo: "blocked")
            .get();

    return snap.docs.map((d) => d.data()).toList();
  }
}
