import 'package:flutter/material.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../presentation/classroom_screen.dart';

class ClassroomFilterSwitch extends StatelessWidget {
  final ClassroomFilter value;
  final ValueChanged<ClassroomFilter> onChanged;
  final bool showEnrolled;

  const ClassroomFilterSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.showEnrolled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _chip("Teachers", ClassroomFilter.teachers),
          const SizedBox(width: 10),
          _chip("Students", ClassroomFilter.students),

          if (showEnrolled) ...[
            const SizedBox(width: 10),
            _chip("Enrolled", ClassroomFilter.enrolled),
          ],
        ],
      ),
    );
  }

  Widget _chip(String label, ClassroomFilter type) {
    final selected = value == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                selected
                    ? AppColors.primaryLight
                    : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
