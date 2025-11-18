import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider;

import '../controller/student_controller.dart';
import '../model/student_repository.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  );
});

final studentControllerProvider =
    StateNotifierProvider<StudentController, StudentState>((ref) {
      return StudentController(ref.read(studentRepositoryProvider));
    });
