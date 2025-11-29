import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

class UserDetailsHeader extends StatelessWidget {
  final String displayName;
  final String email;
  final String? profileImage;

  const UserDetailsHeader({
    super.key,
    required this.displayName,
    required this.email,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage =
        profileImage != null && profileImage!.trim().isNotEmpty;

    final bool isSame =
        displayName.trim().toLowerCase() == email.trim().toLowerCase();

    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: Colors.white24,
          backgroundImage: hasImage ? NetworkImage(profileImage!) : null,
          child:
              !hasImage
                  ? const Icon(LucideIcons.user, size: 32, color: Colors.white)
                  : null,
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isSame ? email : displayName,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),

              if (!isSame) ...[
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontFamily: AppTypography.family,
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
