import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/concept_vault_grid.dart';
import 'widgets/dashboard_app_bar.dart';
import 'widgets/notify_hub_card.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/top_teacher_card.dart';
import 'widgets/user_distribution_card.dart';
import 'widgets/pulse_board_grid.dart';
import '../../../../../ui/design_system/tokens/colors.dart';

class AdminDashboardHomeScreen extends ConsumerWidget {
  const AdminDashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.secondaryDark,
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(292),
        child: const DashboardAppBar(),
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
