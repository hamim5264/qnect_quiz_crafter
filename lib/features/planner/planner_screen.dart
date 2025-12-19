import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import 'data/planner_providers.dart';
import 'widgets/add_task_dialog.dart';
import 'widgets/planner_task_card.dart';

enum PlannerFilter { all, pending, completed }

class PlannerScreen extends ConsumerStatefulWidget {
  const PlannerScreen({super.key});

  @override
  ConsumerState<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends ConsumerState<PlannerScreen> {
  PlannerFilter filter = PlannerFilter.all;

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(plannerTasksProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Planner"),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryLight,
        onPressed:
            () => showDialog(
              context: context,
              builder: (_) => const AddTaskDialog(),
            ),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _filterChip("All", PlannerFilter.all),
                _filterChip("Pending", PlannerFilter.pending),
                _filterChip("Completed", PlannerFilter.completed),
              ],
            ),

            const SizedBox(height: 18),

            Expanded(
              child: tasksAsync.when(
                loading: () => const Center(child: AppLoader()),
                error:
                    (_, __) =>
                        const Center(child: Text("Failed to load tasks")),
                data: (tasks) {
                  final filtered =
                      tasks.where((t) {
                        if (filter == PlannerFilter.pending) {
                          return t['completed'] == false;
                        }
                        if (filter == PlannerFilter.completed) {
                          return t['completed'] == true;
                        }
                        return true;
                      }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.checkmark_circle,
                            size: 64,
                            color: Colors.white54,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "No tasks yet",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => PlannerTaskCard(task: filtered[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, PlannerFilter value) {
    final active = filter == value;

    return GestureDetector(
      onTap: () => setState(() => filter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color:
              active
                  ? AppColors.primaryLight
                  : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: active ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}
