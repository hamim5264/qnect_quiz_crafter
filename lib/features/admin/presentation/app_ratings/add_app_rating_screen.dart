import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/app_loader.dart';
import '../../../../../common/widgets/common_rounded_app_bar.dart';

class AddAppRatingScreen extends StatefulWidget {
  const AddAppRatingScreen({super.key});

  @override
  State<AddAppRatingScreen> createState() => _AddAppRatingScreenState();
}

class _AddAppRatingScreenState extends State<AddAppRatingScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final commentCtrl = TextEditingController();

  int performance = 5;
  int privacy = 5;
  int experience = 5;

  bool loading = false;

  @override
  void dispose() {
    commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonRoundedAppBar(title: 'Add Rating'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _starsRow('Performance', performance, (v) {
                setState(() => performance = v);
              }),
              const SizedBox(height: 14),
              _starsRow('Fairness & Privacy', privacy, (v) {
                setState(() => privacy = v);
              }),
              const SizedBox(height: 14),
              _starsRow('Experience', experience, (v) {
                setState(() => experience = v);
              }),

              const SizedBox(height: 18),

              TextField(
                controller: commentCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  filled: false,
                  hintText: 'Write your comment',
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
                  onPressed: loading ? null : _submit,
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

  Widget _starsRow(String title, int value, ValueChanged<int> onTap) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        Row(
          children: List.generate(
            5,
            (i) => IconButton(
              icon: Icon(
                Icons.star,
                color: i < value ? Colors.amber : Colors.grey,
              ),
              onPressed: () => onTap(i + 1),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    setState(() => loading = true);

    final userSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final firstName = userSnap.data()?['firstName']?.toString() ?? '';
    final lastName = userSnap.data()?['lastName']?.toString() ?? '';
    final profileImage = userSnap.data()?['profileImage']?.toString();

    final userName =
        ('$firstName $lastName').trim().isEmpty
            ? 'Unknown User'
            : ('$firstName $lastName').trim();

    await FirebaseFirestore.instance.collection('app_ratings').add({
      'userId': uid,
      'userName': userName,
      'profileImage': profileImage ?? '',
      'performance': performance,
      'privacy': privacy,
      'experience': experience,
      'comment': commentCtrl.text.trim(),
      'createdAt': Timestamp.now(),
    });

    if (!mounted) return;
    Navigator.pop(context);
  }
}
