import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../controllers/teacher_controller.dart';
import '../repository/teacher_repository.dart';
import '../models/teacher_state.dart';

final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  return TeacherRepository(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  );
});

final teacherControllerProvider =
    StateNotifierProvider<TeacherController, TeacherState>((ref) {
      return TeacherController(ref.read(teacherRepositoryProvider));
    });
