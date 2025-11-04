import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class UserDetailsHeader extends StatelessWidget {
  final String role;

  const UserDetailsHeader({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 36,
          backgroundImage: AssetImage('assets/images/admin/sample_teacher.png'),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role == "Teacher" ? "Mst. Hasna Hena" : "Rafiul Islam",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                role == "Teacher" ? "Instructor" : "Student",
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: AppTypography.family,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
