import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qnect_quiz_crafter/features/admin/presentation/manage_users/widgets/manage_user_background_painter.dart';
import '../../../../ui/design_system/tokens/colors.dart';

import 'controllers/user_list_controller.dart';
import 'growth/admin_growth_controller.dart';
import 'widgets/manage_user_header.dart';
import 'widgets/manage_user_search_bar.dart';
import 'widgets/manage_user_stat_cards.dart';
import 'widgets/manage_user_growth_card.dart';
import 'widgets/manage_user_filter_tabs.dart';
import 'widgets/manage_user_card.dart';
import 'widgets/user_card_skeleton.dart';

class ManageUsersScreen extends ConsumerStatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  ConsumerState<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends ConsumerState<ManageUsersScreen> {
  String selectedFilter = "Teacher";
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(userListControllerProvider.notifier).loadUsers("Teacher");
    });
  }

  @override
  Widget build(BuildContext context) {
    final growthState = ref.watch(adminGrowthControllerProvider);
    final userListState = ref.watch(userListControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          const ManageUserBackground(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ManageUserHeader(),
                  const SizedBox(height: 20),

                  ManageUserSearchBar(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() => searchQuery = value.trim().toLowerCase());
                    },
                  ),
                  const SizedBox(height: 20),

                  const ManageUserStatCards(),
                  const SizedBox(height: 16),

                  ManageUserGrowthCard(
                    isLoading: growthState.loading,
                    currentMonthUsers: growthState.currentMonthUsers,
                    previousMonthUsers: growthState.previousMonthUsers,
                  ),

                  const SizedBox(height: 20),

                  ManageUserFilterTabs(
                    selectedFilter: selectedFilter,
                    onFilterChanged: (value) {
                      setState(() => selectedFilter = value);
                      ref
                          .read(userListControllerProvider.notifier)
                          .loadUsers(value);
                    },
                  ),

                  const SizedBox(height: 20),

                  userListState.when(
                    loading:
                        () => Column(
                          children: List.generate(
                            5,
                            (_) => const UserCardSkeleton(),
                          ),
                        ),
                    error:
                        (e, st) => Text(
                          "Error: $e",
                          style: const TextStyle(color: Colors.red),
                        ),
                    data: (users) {
                      final matchedUsers =
                          users.where((u) {
                            final fullName =
                                "${u['firstName']} ${u['lastName']}"
                                    .toLowerCase();
                            return fullName.contains(searchQuery);
                          }).toList();

                      if (matchedUsers.isEmpty) {
                        return const Center(
                          child: Text(
                            "No users found",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return Column(
                        children:
                            matchedUsers.map((user) {
                              return ManageUserCard(
                                name:
                                    "${user['firstName']} ${user['lastName']}",
                                email: user['email'] ?? "",
                                image: user['profileImage'] ?? "",
                                role: selectedFilter,
                              );
                            }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
