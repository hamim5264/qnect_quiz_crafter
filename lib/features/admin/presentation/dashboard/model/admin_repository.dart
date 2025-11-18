import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/admin_model.dart';

class AdminRepository {
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;

  AdminRepository(this._db, this._storage);

  Future<AdminModel> getAdmin(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception("Admin document not found for uid: $uid");
    }

    return AdminModel.fromMap(doc.data()!);
  }

  Future<void> updateAdminName(
    String uid,
    String firstName,
    String lastName,
  ) async {
    await _db.collection('users').doc(uid).update({
      "firstName": firstName,
      "lastName": lastName,
    });
  }

  Future<String> uploadProfileImage(String uid, File image) async {
    final ext = image.path.split('.').last.toLowerCase();
    final mime = ext == "png" ? "image/png" : "image/jpeg";

    final ref = _storage.ref().child(
      "profile_images/$uid/profile_${DateTime.now().millisecondsSinceEpoch}.$ext",
    );

    await ref.putFile(image, SettableMetadata(contentType: mime));

    return await ref.getDownloadURL();
  }

  Future<void> updateProfileImage(String uid, String url) async {
    await _db.collection('users').doc(uid).update({"profileImage": url});
  }
}
