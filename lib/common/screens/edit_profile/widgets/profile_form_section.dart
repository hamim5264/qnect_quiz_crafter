import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/common/screens/edit_profile/widgets/profile_date_picker.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import '../../../../common/widgets/app_loader.dart';
import '../../../widgets/action_error_dialog.dart';
import '../../../widgets/action_success_dialog.dart';
import 'form_field_skeleton.dart';

class ProfileFormSection extends StatelessWidget {
  final String role;

  final String? firstName;
  final String? lastName;
  final String? phone;
  final DateTime dob;
  final ValueChanged<DateTime> onDobChanged;
  final String? resumeLink;
  final String? address;

  final bool isLoading;
  final bool isSaving;

  final Future<void> Function() onSave;

  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController dobCtrl;
  final TextEditingController resumeCtrl;
  final TextEditingController addressCtrl;

  const ProfileFormSection({
    super.key,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.dob,
    required this.onDobChanged,
    required this.resumeLink,
    required this.address,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.phoneCtrl,
    required this.dobCtrl,
    required this.resumeCtrl,
    required this.addressCtrl,
    required this.isLoading,
    required this.isSaving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == "admin";

    return Column(
      children: [
        isLoading
            ? const FormFieldSkeleton()
            : _buildInput(firstNameCtrl, "First Name"),
        isLoading
            ? const FormFieldSkeleton()
            : _buildInput(lastNameCtrl, "Last Name"),
        isLoading
            ? const FormFieldSkeleton()
            : _buildInput(
              phoneCtrl,
              "Phone Number",
              enabled: !isAdmin,
              hint: isAdmin ? "Not required for Admin" : null,
            ),

        isLoading
            ? const FormFieldSkeleton()
            : ProfileDatePicker(
              selectedDate: dob,
              onDateSelected: (newDate) {
                onDobChanged(newDate);
                dobCtrl.text =
                    "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
              },
            ),

        if (role == "teacher")
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child:
                isLoading
                    ? const FormFieldSkeleton()
                    : _buildInput(
                      resumeCtrl,
                      "Resume Link",
                      hint: "Link to your CV / Portfolio",
                    ),
          ),

        Padding(
          padding: EdgeInsets.only(
            top:
                role == "student"
                    ? 10
                    : role == "admin"
                    ? 10
                    : 0,
          ),
          child:
              isLoading
                  ? const FormFieldSkeleton()
                  : _buildInput(
                    addressCtrl,
                    "Address",
                    enabled: !isAdmin,
                    hint: isAdmin ? "Not required for Admin" : null,
                  ),
        ),

        const SizedBox(height: 18),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                isSaving
                    ? null
                    : () async {
                      try {
                        await onSave();

                        if (!context.mounted) return;

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder:
                              (_) => ActionSuccessDialog(
                                title: "Profile Updated",
                                message:
                                    "Your profile details were successfully saved.",
                                onConfirm: () => Navigator.of(context).pop(),
                              ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;

                        showDialog(
                          context: context,
                          builder:
                              (_) => ActionErrorDialog(message: e.toString()),
                        );
                      }
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryDark,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child:
                isSaving
                    ? const AppLoader(size: 28, color: Colors.white)
                    : const Text(
                      "Update",
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
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
        controller: controller,
        enabled: enabled,
        cursorColor: AppColors.primaryLight,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(
            color: Colors.white70,
            fontFamily: AppTypography.family,
          ),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.08),
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
