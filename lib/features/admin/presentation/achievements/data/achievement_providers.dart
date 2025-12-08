import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'achievement_service.dart';

final achievementServiceProvider =
Provider((ref) => AchievementService());

/// Users eligible for badges
final eligibleUsersProvider = FutureProvider.family((ref, String role) async {
  final service = ref.watch(achievementServiceProvider);
  return service.getEligibleUsers(role);
});
