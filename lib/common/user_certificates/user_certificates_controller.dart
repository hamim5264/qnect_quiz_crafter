import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class UserCertificate {
  final String id;
  final String certName;
  final String issueDate;
  final int levelGroup; // 5 or 10

  const UserCertificate({
    required this.id,
    required this.certName,
    required this.issueDate,
    required this.levelGroup,
  });

  factory UserCertificate.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserCertificate(
      id: doc.id,
      certName: data['certName'] ?? '',
      issueDate: data['issueDate'] ?? '',
      levelGroup: data['levelGroup'] ?? 5,
    );
  }
}

class UserCertificatesState {
  final bool loading;
  final List<UserCertificate> items;

  const UserCertificatesState({
    required this.loading,
    required this.items,
  });

  factory UserCertificatesState.initial() =>
      const UserCertificatesState(loading: true, items: []);
}

class UserCertificatesController
    extends StateNotifier<UserCertificatesState> {
  UserCertificatesController() : super(UserCertificatesState.initial()) {
    _load();
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      state = const UserCertificatesState(loading: false, items: []);
      return;
    }

    // Fetch certificates from GLOBAL collection
    final snap = await FirebaseFirestore.instance
        .collection('certificates')
        .where('userId', isEqualTo: uid)
        .get();

    final items = snap.docs.map((e) => UserCertificate.fromDoc(e)).toList();

    state = UserCertificatesState(
      loading: false,
      items: items,
    );
  }

  Future<void> refresh() => _load();
}

final userCertificatesProvider =
StateNotifierProvider<UserCertificatesController, UserCertificatesState>(
        (ref) => UserCertificatesController());
