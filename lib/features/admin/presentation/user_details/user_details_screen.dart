import 'package:flutter/material.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import 'widgets/user_overview_card.dart';
import 'widgets/user_info_section.dart';

class UserDetailsScreen extends StatefulWidget {
  final String role;

  const UserDetailsScreen({super.key, required this.role});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool _isExpanded = false;
  bool _hasChanged = false;
  String selectedStatus = "Approved";
  bool accessControl = true;

  final List<String> statusOptions = ["Approved", "Pending", "Rejected"];

  void _toggleExpand() => setState(() => _isExpanded = !_isExpanded);

  void _onFieldChanged() => setState(() => _hasChanged = true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "User Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _toggleExpand,
              child: UserOverviewCard(
                role: widget.role,
                isExpanded: _isExpanded,
                onChanged: _onFieldChanged,
              ),
            ),
            const SizedBox(height: 20),

            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState:
                  _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: UserInfoSection(
                role: widget.role,
                selectedStatus: selectedStatus,
                accessControl: accessControl,
                onStatusChanged: (val) {
                  setState(() {
                    selectedStatus = val;
                    _hasChanged = true;
                  });
                },
                onAccessChanged: (val) {
                  setState(() {
                    accessControl = val;
                    _hasChanged = true;
                  });
                },
                hasChanged: _hasChanged,
                onUpdated: () => setState(() => _hasChanged = false),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
