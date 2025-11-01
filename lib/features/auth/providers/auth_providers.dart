import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../application/auth_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (_) => FirebaseAuth.instance,
);

final firestoreProvider = Provider<FirebaseFirestore>(
  (_) => FirebaseFirestore.instance,
);

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.read(firebaseAuthProvider),
    ref.read(firestoreProvider),
  );
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.read(authServiceProvider).authStateChanges();
});
