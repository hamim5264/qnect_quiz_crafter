import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../common/widgets/app_skeleton.dart';

import 'widgets/teacher_request_header.dart';
import 'widgets/teacher_request_info_card.dart';
import 'widgets/teacher_request_actions.dart';

class TeacherRequestScreen extends StatefulWidget {
  const TeacherRequestScreen({super.key});

  @override
  State<TeacherRequestScreen> createState() => _TeacherRequestScreenState();
}

class _TeacherRequestScreenState extends State<TeacherRequestScreen> {
  final _db = FirebaseFirestore.instance;

  final Set<String> _expandedIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Teachers Request'),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            _db
                .collection('users')
                .where('role', isEqualTo: 'teacher')
                .where(
                  'accountStatus',
                  whereIn: ['pending', 'rejected', 'blocked'],
                )
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSkeletonList();
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Failed to load teacher requests.",
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: AppTypography.family,
                ),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No teacher requests right now.",
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: AppTypography.family,
                  fontSize: 14,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 18),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();
              final uid = doc.id;

              final firstName = (data['firstName'] ?? '') as String;
              final lastName = (data['lastName'] ?? '') as String;
              final nameRaw = '$firstName $lastName'.trim();
              final name = nameRaw.isEmpty ? 'Unknown Teacher' : nameRaw;

              final email = (data['email'] ?? 'unknown@mail.com') as String;

              final dobIso = data['dob'] as String?;
              String dobText = 'Not set';
              if (dobIso != null && dobIso.isNotEmpty) {
                final dt = DateTime.tryParse(dobIso);
                if (dt != null) {
                  dobText =
                      '${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)} ${dt.year}';
                }
              }

              final phone = (data['phone'] ?? 'Not set') as String;
              final address = (data['address'] ?? 'Not set') as String;
              final resume = (data['resumeLink'] ?? 'Not provided') as String;
              final status = (data['accountStatus'] ?? 'pending') as String;

              final attemptCount =
                  (data['attemptCount'] ?? 0) is int
                      ? data['attemptCount'] as int
                      : 0;
              final remaining = (3 - attemptCount);
              final remainingClamped = remaining < 0 ? 0 : remaining;

              final expanded = _expandedIds.contains(uid);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TeacherRequestHeader(
                    expanded: expanded,
                    name: name,
                    email: email,
                    avatar: '',
                    onToggle: () {
                      setState(() {
                        if (expanded) {
                          _expandedIds.remove(uid);
                        } else {
                          _expandedIds.add(uid);
                        }
                      });
                    },
                  ),

                  if (expanded) ...[
                    const SizedBox(height: 16),
                    TeacherRequestInfoCard(
                      email: email,
                      dob: dobText,
                      phone: phone,
                      address: address,
                      resume: resume,
                      status: status,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Request remaining for this user: $remainingClamped',
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TeacherRequestActions(
                      teacherId: uid,
                      teacherName: name,
                      teacherEmail: email,
                      currentStatus: status,
                      remainingRequests: remainingClamped,
                      onStatusChanged: (_) {},
                      onRejectAttempt: () {},
                    ),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 2,
      separatorBuilder: (_, __) => const SizedBox(height: 18),
      itemBuilder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const AppSkeleton(
                    width: 56,
                    height: 56,
                    borderRadius: BorderRadius.all(Radius.circular(28)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        AppSkeleton(width: 130, height: 14),
                        SizedBox(height: 6),
                        AppSkeleton(width: 180, height: 12),
                        SizedBox(height: 8),
                        AppSkeleton(width: 70, height: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            const AppSkeleton(
              height: 110,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            const SizedBox(height: 12),

            const AppSkeleton(
              height: 44,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            const SizedBox(height: 8),
            const AppSkeleton(
              height: 44,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            const SizedBox(height: 8),
            const AppSkeleton(
              height: 44,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ],
        );
      },
    );
  }

  String _monthName(int m) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    if (m < 1 || m > 12) return '';
    return months[m - 1];
  }
}
