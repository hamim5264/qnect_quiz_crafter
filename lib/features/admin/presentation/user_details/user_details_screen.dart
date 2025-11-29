import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import 'widgets/user_overview_card.dart';
import 'widgets/user_info_section.dart';

class UserDetailsScreen extends StatefulWidget {
  final String role;
  final String email;

  const UserDetailsScreen({super.key, required this.role, required this.email});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool _isExpanded = false;
  bool _hasChanged = false;

  String selectedStatus = "Approved";
  bool accessControl = true;

  final List<String> statusOptions = ["Approved", "Pending", "Rejected"];

  bool _loading = true;
  String? _userId;
  Map<String, dynamic>? _userData;

  void _toggleExpand() => setState(() => _isExpanded = !_isExpanded);

  void _markChanged() => setState(() => _hasChanged = true);

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final snap =
          await FirebaseFirestore.instance
              .collection("users")
              .where("email", isEqualTo: widget.email.trim())
              .limit(1)
              .get();

      if (snap.docs.isEmpty) {
        if (mounted) {
          setState(() => _loading = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("User not found")));
        }
        return;
      }

      final doc = snap.docs.first;
      final data = doc.data();

      final accountStatus =
          (data["accountStatus"] as String?)?.toLowerCase() ?? "approved";

      final isBlocked = accountStatus == "blocked";
      final bool isTeacher =
          (data["role"] as String?)?.toLowerCase() == "teacher";

      String uiStatus = "Approved";
      if (!isBlocked) {
        if (accountStatus == "pending") {
          uiStatus = "Pending";
        } else if (accountStatus == "rejected") {
          uiStatus = "Rejected";
        } else {
          uiStatus = "Approved";
        }
      }

      setState(() {
        _userId = doc.id;
        _userData = data;
        accessControl = !isBlocked;
        selectedStatus = isTeacher ? uiStatus : "Approved";
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to load user: $e")));
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_userId == null || _userData == null) return;

    final firestore = FirebaseFirestore.instance;

    final bool isTeacher =
        (_userData!["role"] as String?)?.toLowerCase() == "teacher";

    String accountStatusToStore;

    if (!accessControl) {
      accountStatusToStore = "blocked";
    } else {
      if (isTeacher) {
        accountStatusToStore = selectedStatus.toLowerCase();
      } else {
        accountStatusToStore = "approved";
      }
    }

    await firestore.collection("users").doc(_userId).update({
      "accountStatus": accountStatusToStore,
    });

    if (isTeacher) {
      await firestore
          .collection("teacher_status_lookup")
          .doc(widget.email.trim())
          .set({
            "accountStatus": accountStatusToStore,
            "email": widget.email.trim(),
            "uid": _userData!["uid"],
          }, SetOptions(merge: true));
    }
  }

  Future<void> _deleteUser() async {
    if (_userId == null || _userData == null) return;

    final firestore = FirebaseFirestore.instance;
    final bool isTeacher =
        (_userData!["role"] as String?)?.toLowerCase() == "teacher";

    await firestore.collection("users").doc(_userId).delete();

    if (isTeacher) {
      await firestore
          .collection("teacher_status_lookup")
          .doc(widget.email.trim())
          .delete()
          .catchError((_) {});
    }
  }

  String _getDisplayName() {
    if (_userData == null) {
      return widget.email;
    }

    if (_userData!["name"] != null &&
        _userData!["name"].toString().trim().isNotEmpty) {
      return _userData!["name"].toString().trim();
    }

    final feedbackRaw = _userData!["feedback"];

    if (feedbackRaw is Map) {
      final first = feedbackRaw["firstName"]?.toString().trim() ?? "";
      final last = feedbackRaw["lastName"]?.toString().trim() ?? "";
      final full = "$first $last".trim();

      if (full.isNotEmpty) return full;
    }

    if (feedbackRaw is List && feedbackRaw.isNotEmpty) {
      final firstItem = feedbackRaw.first;

      if (firstItem is Map) {
        final first = firstItem["firstName"]?.toString().trim() ?? "";
        final last = firstItem["lastName"]?.toString().trim() ?? "";
        final full = "$first $last".trim();

        if (full.isNotEmpty) return full;
      }
    }

    final firstName = _userData!["firstName"]?.toString().trim() ?? "";
    final lastName = _userData!["lastName"]?.toString().trim() ?? "";
    final fullRoot = "$firstName $lastName".trim();

    if (fullRoot.isNotEmpty) return fullRoot;

    return widget.email;
  }

  String? _getProfileImage() {
    if (_userData == null) return null;
    return _userData!["profileImage"] as String?;
  }

  List<String> _buildBulletItems() {
    if (_userData == null) {
      if (widget.role == "Teacher") {
        return const [
          "0 Courses Created",
          "0 Quizzes Created",
          "0 Liked",
          "0% Monthly Growth",
        ];
      } else {
        return const [
          "0 Courses Enrolled",
          "0 Quizzes Given",
          "No Group",
          "Level: N/A",
        ];
      }
    }

    final bool isTeacher =
        (_userData!["role"] as String?)?.toLowerCase() == "teacher";

    if (isTeacher) {
      final courses = _userData!["totalCourses"] ?? 0;
      final quizzes = _userData!["totalQuizzes"] ?? 0;
      final liked = _userData!["totalLikes"] ?? 0;
      final growth = _userData!["monthlyGrowth"] ?? 0;

      return [
        "$courses Courses Created",
        "$quizzes Quizzes Created",
        "$liked Liked",
        "$growth% Monthly Growth",
      ];
    } else {
      final group = _userData!["group"] ?? "No Group";
      final level = _userData!["level"] ?? "N/A";
      final enrolled = _userData!["coursesEnrolled"] ?? 0;
      final quizzesGiven = _userData!["quizzesGiven"] ?? 0;

      return [
        "$enrolled Courses Enrolled",
        "$quizzesGiven Quizzes Given",
        "$group Group",
        "Level: $level",
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "User Details"),
      body:
          _loading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _toggleExpand,
                      child: UserOverviewCard(
                        role: widget.role,
                        isExpanded: _isExpanded,
                        onChanged: _markChanged,
                        displayName: _getDisplayName(),
                        profileImage: _getProfileImage(),
                        bulletItems: _buildBulletItems(),
                        email: (_userData?["email"] ?? widget.email),
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
                      secondChild:
                          _userData == null
                              ? const SizedBox.shrink()
                              : UserInfoSection(
                                role: widget.role,
                                email:
                                    (_userData!["email"] as String?) ??
                                    widget.email,
                                phone:
                                    (_userData!["phone"] as String?) ?? "N/A",
                                address:
                                    (_userData!["address"] as String?) ?? "N/A",
                                resumeLink:
                                    (_userData!["resumeLink"] as String?),
                                level: (_userData!["level"]?.toString()) ?? "0",
                                certificates:
                                    (_userData!["certificateCount"]
                                        ?.toString()) ??
                                    "0",
                                badges:
                                    (_userData!["badgeCount"]?.toString()) ??
                                    "0",
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
                                onUpdated:
                                    () => setState(() => _hasChanged = false),
                                onSave: _saveChanges,
                                onDelete: _deleteUser,
                              ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
    );
  }
}
