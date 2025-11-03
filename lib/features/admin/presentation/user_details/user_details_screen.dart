import 'package:flutter/material.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import 'widgets/user_primary_info_card.dart';
import 'widgets/user_details_header.dart';
import 'widgets/user_info_row.dart';

class UserDetailsScreen extends StatefulWidget {
  final String role;

  const UserDetailsScreen({super.key, required this.role});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  String selectedStatus = "Approved";
  bool accessControl = true;
  bool hasChanged = false;

  final List<String> statusOptions = ["Approved", "Pending", "Rejected"];

  void _showAccessConfirmDialog(bool newValue) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.primaryDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "Are you sure?",
              style: TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              newValue
                  ? "You are about to un-restrict this user’s access."
                  : "You are about to restrict this user’s access.",
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white70,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    accessControl = newValue;
                    hasChanged = true;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    accessControl = newValue;
                    hasChanged = true;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.role;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "User Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            UserPrimaryInfoCard(child: UserDetailsHeader(role: role)),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Divider(
                    thickness: 2.5,
                    indent: 80,
                    endIndent: 80,
                    color: AppColors.secondaryDark,
                  ),
                  const SizedBox(height: 12),
                  const UserInfoRow(
                    label: "Email",
                    value: "hena.quizcrafter@gmail.com",
                  ),
                  const UserInfoRow(
                    label: "Phone",
                    value: "+880 17** - XXXXXX",
                  ),
                  const UserInfoRow(
                    label: "Address",
                    value: "Uttara, Sector-10, Dhaka",
                  ),
                  if (role == "Teacher")
                    const UserInfoRow(
                      label: "Resume Link",
                      value: "https://www.resumefinder.hasna",
                    ),
                  if (role == "Student")
                    const UserInfoRow(label: "Resume Link", value: "None"),
                  const UserInfoRow(label: "Level", value: "6"),
                  const UserInfoRow(label: "Certificate", value: "2"),
                  const UserInfoRow(label: "Badges", value: "4"),

                  UserInfoRow(
                    label: "Status",
                    value: selectedStatus,
                    hasDropdown: true,
                    dropdownItems: statusOptions,
                    selectedValue: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                        hasChanged = true;
                      });
                    },
                  ),

                  UserInfoRow(
                    label: "Access Control",
                    value: accessControl ? "Unblocked" : "Blocked",
                    hasSwitch: true,
                    switchValue: accessControl,
                    onSwitchChanged: (value) => _showAccessConfirmDialog(value),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          hasChanged
                              ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "User updated successfully",
                                      style: TextStyle(
                                        fontFamily: AppTypography.family,
                                      ),
                                    ),
                                  ),
                                );
                                setState(() => hasChanged = false);
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            hasChanged
                                ? AppColors.primaryDark
                                : Colors.white.withValues(alpha: 0.3),
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
