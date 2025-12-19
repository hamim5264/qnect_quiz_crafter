import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import 'package:qnect_quiz_crafter/common/widgets/common_rounded_app_bar.dart';

class AddFeedbackScreen extends StatefulWidget {
  const AddFeedbackScreen({super.key});

  @override
  State<AddFeedbackScreen> createState() => _AddFeedbackScreenState();
}

class _AddFeedbackScreenState extends State<AddFeedbackScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  String? courseId;
  String? courseTitle;
  String? teacherId;
  String? teacherName;

  int stars = 5;
  bool loading = false;
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonRoundedAppBar(title: "Add Feedback"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<QuerySnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .collection('myCourses')
                        .get(),
                builder: (_, snap) {
                  if (!snap.hasData) {
                    return const Center(child: AppLoader(size: 32));
                  }

                  final docs = snap.data!.docs;

                  if (docs.isEmpty) {
                    return const Text(
                      'You are not enrolled in any course or you dont have the permission!',
                      style: TextStyle(color: Colors.grey),
                    );
                  }

                  return DropdownButtonFormField<String>(
                    value: courseId,
                    hint: const Text(
                      'Select Course',
                      style: TextStyle(color: Colors.white54),
                    ),
                    iconEnabledColor: Colors.white54,
                    decoration: const InputDecoration(
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    items:
                        docs.map((d) {
                          return DropdownMenuItem(
                            value: d.id,
                            child: FutureBuilder<DocumentSnapshot>(
                              future:
                                  FirebaseFirestore.instance
                                      .collection('courses')
                                      .doc(d.id)
                                      .get(),
                              builder: (_, courseSnap) {
                                if (!courseSnap.hasData) {
                                  return const Text('Loading...');
                                }
                                return Text(
                                  courseSnap.data!['title'],
                                  style: const TextStyle(fontSize: 14),
                                );
                              },
                            ),
                          );
                        }).toList(),
                    onChanged: _onCourseSelected,
                  );
                },
              ),

              const SizedBox(height: 16),

              if (courseTitle != null)
                Text(
                  'Course: $courseTitle',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

              if (teacherName != null)
                Text(
                  'Teacher: $teacherName',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    icon: Icon(
                      Icons.star,
                      color: i < stars ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () => setState(() => stars = i + 1),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: controller,
                maxLines: 3,
                decoration: const InputDecoration(
                  filled: false,
                  hintText: 'Write your feedback',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed:
                      loading || courseId == null ? null : _submitFeedback,
                  child:
                      loading
                          ? const AppLoader(size: 24)
                          : const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onCourseSelected(String? id) async {
    if (id == null) return;

    final existing =
        await FirebaseFirestore.instance
            .collection('feedback')
            .where('courseId', isEqualTo: id)
            .where('userId', isEqualTo: uid)
            .limit(1)
            .get();

    if (existing.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already reviewed this course')),
      );
      return;
    }

    final courseSnap =
        await FirebaseFirestore.instance.collection('courses').doc(id).get();

    final teacherIdLocal = courseSnap['teacherId'];

    final teacherSnap =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(teacherIdLocal)
            .get();

    setState(() {
      courseId = id;
      courseTitle = courseSnap['title'];
      teacherId = teacherIdLocal;
      teacherName = '${teacherSnap['firstName']} ${teacherSnap['lastName']}';
    });
  }

  Future<void> _submitFeedback() async {
    setState(() => loading = true);

    final userSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    await FirebaseFirestore.instance.collection('feedback').add({
      'userId': uid,
      'userName': '${userSnap['firstName']} ${userSnap['lastName']}',
      'profileImage': userSnap['profileImage'] ?? '',
      'teacherName': teacherName,
      'courseId': courseId,
      'courseName': courseTitle,
      'stars': stars,
      'comment': controller.text.trim(),
      'createdAt': Timestamp.now(),
    });

    if (!mounted) return;
    Navigator.pop(context);
  }
}
