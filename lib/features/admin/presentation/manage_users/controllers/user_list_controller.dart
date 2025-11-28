import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../repository/user_list_repository.dart';

final userListRepoProvider = Provider<UserListRepository>((ref) {
  return UserListRepository(FirebaseFirestore.instance);
});

final userListControllerProvider = StateNotifierProvider<
  UserListController,
  AsyncValue<List<Map<String, dynamic>>>
>((ref) {
  return UserListController(ref.read(userListRepoProvider));
});

class UserListController
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final UserListRepository repo;

  UserListController(this.repo) : super(const AsyncValue.loading());

  Future<void> loadUsers(String filter) async {
    state = const AsyncValue.loading();

    try {
      List<Map<String, dynamic>> users = [];

      if (filter == "Teacher") {
        users = await repo.getTeachers();
      } else if (filter == "Student") {
        users = await repo.getStudents();
      } else if (filter == "Blocked") {
        users = await repo.getBlockedUsers();
      }

      state = AsyncValue.data(users);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
