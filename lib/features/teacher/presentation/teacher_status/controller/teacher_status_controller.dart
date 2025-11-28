import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/teacher_status_state.dart';

final teacherStatusControllerProvider =
    NotifierProvider<TeacherStatusController, TeacherStatusState>(
      TeacherStatusController.new,
    );

class TeacherStatusController extends Notifier<TeacherStatusState> {
  final _db = FirebaseFirestore.instance;

  @override
  TeacherStatusState build() => const TeacherStatusState();

  Future<void> loadStatusByEmail(String email) async {
    state = state.copyWith(loading: true);

    final doc =
        await _db.collection("teacher_status_lookup").doc(email.trim()).get();

    if (!doc.exists) {
      state = state.copyWith(
        loading: false,
        status: "not_found",
        email: email.trim(),
        name: null,
      );
      return;
    }

    final data = doc.data()!;

    state = state.copyWith(
      loading: false,
      name: "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim(),
      email: data['email'],
      status: data['accountStatus'] ?? "pending",
      attemptCount: data['attemptCount'] ?? 1,
      rejectionTitle: data['rejectionTitle'],
      rejectionMessage: data['rejectionMessage'],
      feedback: List<String>.from(data['feedback'] ?? []),
    );
  }

  Future<void> resendRequest(String email) async {
    final lookupRef = _db.collection("teacher_status_lookup").doc(email.trim());

    final lookup = await lookupRef.get();
    if (!lookup.exists) return;

    final uid = lookup["uid"];

    await _db.collection("users").doc(uid).update({
      "accountStatus": "pending",
      "attemptCount": FieldValue.increment(1),
      "rejectionTitle": null,
      "rejectionMessage": null,
      "feedback": [],
    });

    await lookupRef.update({
      "accountStatus": "pending",
      "attemptCount": FieldValue.increment(1),
      "rejectionTitle": null,
      "rejectionMessage": null,
      "feedback": [],
    });

    await _db
        .collection("notifications")
        .doc("admin-panel")
        .collection("items")
        .add({
          "type": "teacher_request_resend",
          "email": email.trim(),
          "timestamp": DateTime.now().toIso8601String(),
          "status": "unread",
        });

    state = state.copyWith(
      status: "pending",
      rejectionTitle: null,
      rejectionMessage: null,
      feedback: const [],
    );
  }
}
