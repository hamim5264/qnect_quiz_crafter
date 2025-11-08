import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class UserListDialog extends StatelessWidget {
  final String role;

  const UserListDialog({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final users =
        role == 'Teacher'
            ? ['Mr. Anik', 'Ms. Runa', 'Dr. Hasan', 'Prof. Rubel']
            : ['Hamim', 'Rafiul', 'Araf', 'Sadia'];

    return Dialog(
      backgroundColor: AppColors.primaryLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$role Users",
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(
                      users[i],
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, users[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
