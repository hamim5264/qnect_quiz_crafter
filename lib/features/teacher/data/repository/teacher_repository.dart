import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../models/teacher_model.dart';

class TeacherRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  TeacherRepository(this.firestore, this.storage);

  Future<TeacherModel> getTeacher(String uid) async {
    final doc = await firestore.collection("users").doc(uid).get();
    return TeacherModel.fromMap(doc.data() ?? {});
  }

  Future<void> updateTeacher(TeacherModel model) async {
    await firestore.collection("users").doc(model.uid).update(model.toMap());
  }

  Future<String> uploadImage(String uid, File file) async {
    final ref = storage.ref("teachers/$uid/profile.jpg");
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
