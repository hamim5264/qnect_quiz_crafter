import 'dart:io';
import 'package:flutter_riverpod/legacy.dart';

import '../models/teacher_state.dart';
import '../repository/teacher_repository.dart';

class TeacherController extends StateNotifier<TeacherState> {
  final TeacherRepository repo;

  TeacherController(this.repo) : super(const TeacherState());

  Future<void> loadTeacher(String uid) async {
    state = state.copyWith(loading: true);

    try {
      final model = await repo.getTeacher(uid);
      state = state.copyWith(loading: false, teacher: model);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> updateTeacherProfile({
    required String uid,
    required String firstName,
    required String lastName,
    required String phone,
    required String dob,
    required String address,
    required String resumeLink,
  }) async {
    state = state.copyWith(buttonLoading: true);

    try {
      final updated = state.teacher!.copyWith(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        dob: dob,
        address: address,
        resumeLink: resumeLink,
      );

      await repo.updateTeacher(updated);
      state = state.copyWith(buttonLoading: false, teacher: updated);
    } catch (e) {
      state = state.copyWith(buttonLoading: false, error: e.toString());
    }
  }

  Future<void> updateTeacherImage(String uid, File file) async {
    state = state.copyWith(buttonLoading: true);

    try {
      final url = await repo.uploadImage(uid, file);

      final updated = state.teacher!.copyWith(profileImage: url);
      await repo.updateTeacher(updated);

      state = state.copyWith(buttonLoading: false, teacher: updated);
    } catch (e) {
      state = state.copyWith(buttonLoading: false, error: e.toString());
    }
  }
}
