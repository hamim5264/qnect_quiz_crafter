import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'admin_growth_repository.dart';
import 'admin_growth_state.dart';

final adminGrowthRepoProvider = Provider<AdminGrowthRepository>((ref) {
  return AdminGrowthRepository(FirebaseFirestore.instance);
});

final adminGrowthControllerProvider =
    StateNotifierProvider<AdminGrowthController, AdminGrowthState>((ref) {
      return AdminGrowthController(ref.read(adminGrowthRepoProvider));
    });

class AdminGrowthController extends StateNotifier<AdminGrowthState> {
  final AdminGrowthRepository repo;

  AdminGrowthController(this.repo) : super(const AdminGrowthState()) {
    loadGrowth();
  }

  Future<void> loadGrowth() async {
    state = state.copyWith(loading: true);

    final now = DateTime.now();
    final current = await repo.countUsersForMonth(now.year, now.month);

    final prevMonth = now.month == 1 ? 12 : now.month - 1;
    final prevYear = now.month == 1 ? now.year - 1 : now.year;

    final previous = await repo.countUsersForMonth(prevYear, prevMonth);

    state = state.copyWith(
      currentMonthUsers: current,
      previousMonthUsers: previous,
      loading: false,
    );
  }

  Future<void> loadGrowthForMonth(DateTime selected) async {
    state = state.copyWith(loading: true);

    try {
      final int year = selected.year;
      final int month = selected.month;

      final DateTime previous =
          month == 1 ? DateTime(year - 1, 12) : DateTime(year, month - 1);

      final currentCount = await repo.countUsersForMonth(year, month);
      final previousCount = await repo.countUsersForMonth(
        previous.year,
        previous.month,
      );

      state = state.copyWith(
        loading: false,
        currentMonthUsers: currentCount,
        previousMonthUsers: previousCount,
      );
    } catch (e) {
      state = state.copyWith(loading: false);
    }
  }

  static double calculateGrowth(int previous, int current) {
    if (previous == 0 && current == 0) return 0;

    if (previous == 0 && current > 0) {
      return current.toDouble();
    }

    final double growth = ((current - previous) / previous) * 100;

    if (growth < 0) return 0;

    return double.parse(growth.toStringAsFixed(2));
  }
}
