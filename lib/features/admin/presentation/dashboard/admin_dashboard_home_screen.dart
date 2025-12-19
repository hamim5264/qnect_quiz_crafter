import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'controller/admin_controller.dart';
import 'widgets/concept_vault_grid.dart';
import 'widgets/dashboard_app_bar.dart';
import 'widgets/notify_hub_card.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/top_teacher_card.dart';
import 'widgets/user_distribution_card.dart';
import 'widgets/pulse_board_grid.dart';

import '../../../../../ui/design_system/tokens/colors.dart';

class AdminDashboardHomeScreen extends ConsumerStatefulWidget {
  const AdminDashboardHomeScreen({super.key});

  @override
  ConsumerState<AdminDashboardHomeScreen> createState() =>
      _AdminDashboardHomeScreenState();
}

class _AdminDashboardHomeScreenState
    extends ConsumerState<AdminDashboardHomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      ref.read(adminControllerProvider.notifier).loadAdmin(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.secondaryDark,
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(292),
        child: DashboardAppBar(
          adminName: state.admin?.fullName ?? "Admin",
          adminImageUrl: state.admin?.imageUrl,
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: const [
          SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(child: UserDistributionCard()),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(child: PulseBoardGrid()),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(child: TopTeacherCard()),
          SliverToBoxAdapter(child: SizedBox(height: 30)),
          SliverToBoxAdapter(child: QuickActionsGrid()),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(child: NotifyHubCard()),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(child: ConceptVaultGrid()),
          SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
