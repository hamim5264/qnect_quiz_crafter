import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/student_model.dart';

class StudentRepository {
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;

  StudentRepository(this._db, this._storage);

  Future<StudentModel> getStudent(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception("Student document not found for uid: $uid");
    }

    return StudentModel.fromMap(doc.data()!);
  }

  Future<String> uploadProfileImage(String uid, File file) async {
    final ref = _storage.ref().child("profile_images/$uid/profile.jpg");

    await ref.putFile(file, SettableMetadata(contentType: "image/jpeg"));

    return await ref.getDownloadURL();
  }

  Future<void> updateProfileImage(String uid, String url) async {
    await _db.collection('users').doc(uid).update({"profileImage": url});
  }

  Future<void> updateName(String uid, String first, String last) async {
    await _db.collection('users').doc(uid).update({
      "firstName": first,
      "lastName": last,
    });
  }

  Future<void> updateStudentName(String uid, String first, String last) async {
    await _db.collection('users').doc(uid).update({
      "firstName": first,
      "lastName": last,
    });
  }

  Future<void> updateStudent({
    required String uid,
    required String firstName,
    required String lastName,
    required String phone,
    required String dob,
    required String address,
  }) async {
    await _db.collection('users').doc(uid).update({
      "firstName": firstName,
      "lastName": lastName,
      "phone": phone,
      "dob": dob,
      "address": address,
    });
  }

  Future<void> updateExtraFields(
    String uid, {
    String? phone,
    String? dob,
    String? address,
    String? resume,
  }) async {
    await _db.collection('users').doc(uid).update({
      if (phone != null) "phone": phone,
      if (dob != null) "dob": dob,
      if (address != null) "address": address,
      if (resume != null) "resume": resume,
    });
  }
}
