import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/widgets/common_rounded_app_bar.dart';

import '../../../../../common/widgets/app_loader.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StudentPracticeQuizListScreen extends StatefulWidget {
  const StudentPracticeQuizListScreen({super.key});

  @override
  State<StudentPracticeQuizListScreen> createState() =>
      _StudentPracticeQuizListScreenState();
}

class _StudentPracticeQuizListScreenState
    extends State<StudentPracticeQuizListScreen> {
  String _selectedGroup = 'science';
  String _selectedLevel = 'ssc';

  String? _studentGroup;
  String? _studentLevel;
  bool _loadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadStudentProfile();
  }

  Future<void> _loadStudentProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = snap.data() ?? {};

      _studentGroup = (data['group'] ?? '').toString().toLowerCase();
      _studentLevel = (data['level'] ?? '').toString().toLowerCase();
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      if (mounted) {
        setState(() => _loadingProfile = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CommonRoundedAppBar(title: "Practice Quizzes"),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildFilters(),

            const SizedBox(height: 10),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('practice_quizzes')
                        .where('published', isEqualTo: true)
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: AppLoader());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No practice quizzes found.",
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          color: Colors.white70,
                        ),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  final filtered =
                      docs.where((d) {
                        final group =
                            (d['group'] ?? '').toString().toLowerCase();
                        final level =
                            (d['level'] ?? '').toString().toLowerCase();
                        return group == _selectedGroup &&
                            level == _selectedLevel;
                      }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.exclamationmark_circle,
                            color: Colors.white,
                            size: 60,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "No quiz for this filter.",
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final doc = filtered[index];
                      return _PracticeQuizCard(
                        quizDoc: doc,
                        studentGroup: _studentGroup,
                        studentLevel: _studentLevel,
                        loadingProfile: _loadingProfile,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Group",
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _filterChip(
                label: "Science",
                isSelected: _selectedGroup == 'science',
                onTap: () => setState(() => _selectedGroup = 'science'),
              ),
              const SizedBox(width: 10),
              _filterChip(
                label: "Arts",
                isSelected: _selectedGroup == 'arts',
                onTap: () => setState(() => _selectedGroup = 'arts'),
              ),
              const SizedBox(width: 10),
              _filterChip(
                label: "Commerce",
                isSelected: _selectedGroup == 'commerce',
                onTap: () => setState(() => _selectedGroup = 'commerce'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Level",
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 10,
            children: [
              _filterChip(
                label: "SSC",
                isSelected: _selectedLevel == 'ssc',
                onTap: () => setState(() => _selectedLevel = 'ssc'),
              ),
              _filterChip(
                label: "HSC",
                isSelected: _selectedLevel == 'hsc',
                onTap: () => setState(() => _selectedLevel = 'hsc'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryDark : Colors.white10,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.secondaryDark : Colors.white30,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black : Colors.white70,
          ),
        ),
      ),
    );
  }
}

class _PracticeQuizCard extends StatelessWidget {
  final QueryDocumentSnapshot quizDoc;
  final String? studentGroup;
  final String? studentLevel;
  final bool loadingProfile;

  const _PracticeQuizCard({
    required this.quizDoc,
    required this.studentGroup,
    required this.studentLevel,
    required this.loadingProfile,
  });

  @override
  Widget build(BuildContext context) {
    final quizId = quizDoc.id;
    final title = (quizDoc['title'] ?? 'Untitled').toString();
    final description = (quizDoc['description'] ?? '').toString();
    final group = (quizDoc['group'] ?? '').toString().toLowerCase();
    final level = (quizDoc['level'] ?? '').toString().toLowerCase();
    final questionCount = (quizDoc['questionCount'] ?? 0) as int;
    final durationSeconds =
        (quizDoc.data() as Map<String, dynamic>)['durationSeconds'] ??
        (questionCount * 60);

    final List<dynamic> rawQuestions =
        (quizDoc['questions'] ?? []) as List<dynamic>;
    final List<Map<String, dynamic>> questions =
        rawQuestions.map((e) => Map<String, dynamic>.from(e as Map)).toList();

    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance
              .collection('practice_quizzes')
              .doc(quizId)
              .collection('attempts')
              .doc(uid)
              .get(),
      builder: (context, snapshot) {
        final attempted = snapshot.hasData && snapshot.data!.exists;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white24, width: 1.4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  CupertinoIcons.book_solid,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _smallTag(
                          label: group.toUpperCase(),
                          icon: CupertinoIcons.person_2_fill,
                        ),
                        _smallTag(
                          label: _capitalize(level),
                          icon: CupertinoIcons.book_fill,
                        ),
                        _smallTag(
                          label: "$questionCount QN",
                          icon: CupertinoIcons.doc_on_doc,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              SizedBox(
                width: 110,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        attempted
                            ? Colors.grey.shade500
                            : AppColors.secondaryDark,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),

                  onPressed: () async {
                    if (attempted) {
                      context.pushNamed(
                        'studentPracticeQuizDetails',
                        extra: {
                          "quizId": quizId,
                          "title": title,
                          "questions": questions,
                        },
                      );
                      return;
                    }

                    if (loadingProfile) {
                      _showSnack(
                        context,
                        "Loading your profile, please wait...",
                      );
                      return;
                    }

                    if (studentGroup == null ||
                        studentGroup!.isEmpty ||
                        studentLevel == null ||
                        studentLevel!.isEmpty) {
                      _showSnack(
                        context,
                        "Your group & level are not set. Update your profile first.",
                      );
                      return;
                    }

                    if (studentGroup!.toLowerCase() != group ||
                        studentLevel!.toLowerCase() != level) {
                      _showSnack(
                        context,
                        "You cannot attempt this quiz.\nThis quiz is for ${group.toUpperCase()} ${_capitalize(level)} students.",
                      );
                      return;
                    }

                    context.pushNamed(
                      'studentPracticeQuizInstruction',
                      extra: {
                        "quizId": quizId,
                        "title": title,
                        "durationSeconds": durationSeconds as int,
                        "questions": questions,
                      },
                    );
                  },

                  child: Text(
                    attempted ? "Attempted" : "Attempt",
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: attempted ? Colors.white60 : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _smallTag({required String label, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 11,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          msg,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white,
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
