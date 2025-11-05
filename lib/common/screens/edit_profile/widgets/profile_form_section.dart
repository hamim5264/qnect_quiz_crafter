import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import '../../../widgets/action_feedback_dialog.dart';

class ProfileFormSection extends StatelessWidget {
  final String role;

  const ProfileFormSection({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isTeacher = role == "teacher";
    final isAdmin = role == "admin";

    final firstNameController = TextEditingController(text: "Hasna");
    final lastNameController = TextEditingController(text: "Hena");
    final phoneController = TextEditingController(text: "+88 017** - ******");
    final dobController = TextEditingController(text: "25/05/1987");
    final resumeController = TextEditingController(
      text: "https://dribbble.com/",
    );
    final addressController = TextEditingController(
      text: "Uttara Sector-2, Dhaka, Bangladesh",
    );

    return Column(
      children: [
        _buildInput(firstNameController, "First Name"),
        _buildInput(lastNameController, "Last Name"),
        _buildInput(phoneController, "Phone Number"),
        _buildInput(dobController, "Date of Birth"),
        _buildInput(
          resumeController,
          isTeacher ? "Resume Link" : "Resume Link (N/A)",
          enabled: isTeacher,
          hint:
              isTeacher
                  ? "https://example.com/resume"
                  : "None / You don’t have resume link",
        ),
        _buildInput(addressController, "Address"),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => ActionFeedbackDialog(
                      icon: CupertinoIcons.hand_thumbsup,
                      title: 'Updated',
                      subtitle: 'Your profile has been updated successfully.',
                      buttonText: 'Done',
                      onPressed: () => Navigator.pop(context),
                    ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryDark,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Update",
              style: TextStyle(
                fontFamily: AppTypography.family,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label, {
    bool enabled = true,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: AppColors.primaryLight,
        textInputAction: TextInputAction.next,
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hint ?? "",
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white70,
            fontSize: 13.5,
          ),
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.08),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.secondaryDark),
          ),
        ),
        style: const TextStyle(
          color: Colors.white,
          fontFamily: AppTypography.family,
          fontSize: 14,
        ),
      ),
    );
  }
}
