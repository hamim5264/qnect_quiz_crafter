import 'package:flutter/material.dart';
import '../../../common/widgets/common_curved_background.dart';
import '../../../ui/design_system/tokens/colors.dart';
import 'widgets/profile_header_section.dart';
import 'widgets/profile_form_section.dart';

class EditProfileScreen extends StatelessWidget {
  final String role;

  const EditProfileScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          const CommonCurvedBackground(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white30, width: 1),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "Barlow",
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),

                  const SizedBox(height: 24),
                  ProfileHeaderSection(role: role),
                  const SizedBox(height: 24),
                  ProfileFormSection(role: role),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
