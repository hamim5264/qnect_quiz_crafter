import 'dart:io';

import 'package:flutter_riverpod/legacy.dart'
    show StateNotifier, StateNotifierProvider;

import '../model/admin_model.dart';
import '../model/admin_repository.dart';
import '../provider/admin_providers.dart';

class AdminState {
  final AdminModel? admin;
  final bool loading;
  final bool buttonLoading;

  AdminState({this.admin, this.loading = false, this.buttonLoading = false});

  AdminState copyWith({AdminModel? admin, bool? loading, bool? buttonLoading}) {
    return AdminState(
      admin: admin ?? this.admin,
      loading: loading ?? this.loading,
      buttonLoading: buttonLoading ?? this.buttonLoading,
    );
  }
}

class AdminController extends StateNotifier<AdminState> {
  final AdminRepository _repo;

  AdminController(this._repo) : super(AdminState(loading: true));

  Future<void> loadAdmin(String uid) async {
    state = state.copyWith(loading: true);
    final data = await _repo.getAdmin(uid);
    state = state.copyWith(admin: data, loading: false);
  }

  Future<void> updateName(String uid, String first, String last) async {
    state = state.copyWith(buttonLoading: true);

    await _repo.updateAdminName(uid, first, last);

    await loadAdmin(uid);

    state = state.copyWith(buttonLoading: false);
  }

  Future<void> updateImage(String uid, File file) async {
    state = state.copyWith(buttonLoading: true);

    final url = await _repo.uploadProfileImage(uid, file);

    await _repo.updateProfileImage(uid, url);

    await loadAdmin(uid);

    state = state.copyWith(buttonLoading: false);
  }
}

final adminControllerProvider =
    StateNotifierProvider<AdminController, AdminState>((ref) {
      return AdminController(ref.read(adminRepositoryProvider));
    });
