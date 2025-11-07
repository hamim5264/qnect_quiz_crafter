import 'package:flutter/material.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import 'widgets/teacher_request_header.dart';
import 'widgets/teacher_request_info_card.dart';
import 'widgets/teacher_request_actions.dart';

class TeacherRequestScreen extends StatefulWidget {
  const TeacherRequestScreen({super.key});

  @override
  State<TeacherRequestScreen> createState() => _TeacherRequestScreenState();
}

class _TeacherRequestScreenState extends State<TeacherRequestScreen> {
  bool _expanded = true;
  String _status = 'Pending';
  int _remainingRequests = 2;

  final teacher = {
    'name': 'Mst. Hasna Hena',
    'email': 'hamim5264@diu.edu.bd',
    'dob': '05 March 1998',
    'phone': '+880 17** - XXXXXX',
    'address': 'Uttara, Sector-10, Dhaka',
    'resume': 'https://hamim-info.vercel.app/',
  };

  void _updateStatus(String newStatus) {
    setState(() {
      _status = newStatus;
    });
  }

  void _reduceRemaining() {
    if (_remainingRequests > 0) {
      setState(() {
        _remainingRequests--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Teachers Request'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TeacherRequestHeader(
              expanded: _expanded,
              name: teacher['name']!,
              email: teacher['email']!,
              avatar: 'assets/images/admin/sample_teacher.png',
              onToggle: () => setState(() => _expanded = !_expanded),
            ),
            const SizedBox(height: 16),
            if (_expanded)
              TeacherRequestInfoCard(
                email: teacher['email']!,
                dob: teacher['dob']!,
                phone: teacher['phone']!,
                address: teacher['address']!,
                resume: teacher['resume']!,
                status: _status,
              ),
            const SizedBox(height: 22),
            Text(
              'Request remaining for this user: $_remainingRequests',
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TeacherRequestActions(
              currentStatus: _status,
              remainingRequests: _remainingRequests,
              onStatusChanged: _updateStatus,
              onRejectAttempt: _reduceRemaining,
            ),
          ],
        ),
      ),
    );
  }
}
