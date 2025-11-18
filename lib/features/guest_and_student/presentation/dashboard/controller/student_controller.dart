import 'dart:io';
import '../model/student_model.dart';
import '../model/student_repository.dart';
import 'package:flutter_riverpod/legacy.dart'
    show StateNotifier, StateNotifierProvider;

import '../provider/student_provider.dart';

class StudentState {
  final StudentModel? student;
  final bool loading;
  final bool buttonLoading;

  StudentState({
    this.student,
    this.loading = false,
    this.buttonLoading = false,
  });

  StudentState copyWith({
    StudentModel? student,
    bool? loading,
    bool? buttonLoading,
  }) {
    return StudentState(
      student: student ?? this.student,
      loading: loading ?? this.loading,
      buttonLoading: buttonLoading ?? this.buttonLoading,
    );
  }
}

class StudentController extends StateNotifier<StudentState> {
  final StudentRepository _repo;

  StudentController(this._repo) : super(StudentState(loading: true));

  Future<void> loadStudent(String uid) async {
    state = state.copyWith(loading: true);

    final data = await _repo.getStudent(uid);

    state = state.copyWith(student: data, loading: false);
  }

  Future<void> updateImage(String uid, File file) async {
    state = state.copyWith(buttonLoading: true);

    final url = await _repo.uploadProfileImage(uid, file);
    await _repo.updateProfileImage(uid, url);

    await loadStudent(uid);

    state = state.copyWith(buttonLoading: false);
  }

  Future<void> updateStudentName(String uid, String first, String last) async {
    state = state.copyWith(buttonLoading: true);

    await _repo.updateStudentName(uid, first, last);
    await loadStudent(uid);

    state = state.copyWith(buttonLoading: false);
  }

  Future<void> updateStudentProfile({
    required String uid,
    required String firstName,
    required String lastName,
    required String phone,
    required String dob,
    required String address,
  }) async {
    state = state.copyWith(buttonLoading: true);

    await _repo.updateStudent(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      dob: dob,
      address: address,
    );

    await loadStudent(uid);

    state = state.copyWith(buttonLoading: false);
  }
}

final studentControllerProvider =
    StateNotifierProvider<StudentController, StudentState>((ref) {
      return StudentController(ref.read(studentRepositoryProvider));
    });
