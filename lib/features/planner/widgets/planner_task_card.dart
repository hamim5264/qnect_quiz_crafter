import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class PlannerTaskCard extends StatelessWidget {
  final Map<String, dynamic> task;

  const PlannerTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final completed = task['completed'] as bool;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: completed ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                completed
                    ? Colors.green.withValues(alpha: 0.25)
                    : Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: completed,
            activeColor: AppColors.primaryLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            onChanged: (v) {
              FirebaseFirestore.instance
                  .collection('planner_tasks')
                  .doc(task['id'])
                  .update({'completed': v});
            },
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 14.5,
                    decoration: completed ? TextDecoration.lineThrough : null,
                    color: completed ? Colors.black45 : Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        completed
                            ? Colors.green.withValues(alpha: 0.15)
                            : Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    completed ? "COMPLETED" : "PENDING",
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: completed ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
