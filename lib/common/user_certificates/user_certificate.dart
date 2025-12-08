import 'package:cloud_firestore/cloud_firestore.dart';

class UserCertificate {
  final String id;          // Firestore document ID
  final String userId;      // owner user ID
  final String role;        // Student / Teacher
  final String certName;    // e.g., Foundation Educator
  final String userName;    // Full name of user
  final String issueDate;   // dd/mm/yyyy format

  UserCertificate({
    required this.id,
    required this.userId,
    required this.role,
    required this.certName,
    required this.userName,
    required this.issueDate,
  });

  factory UserCertificate.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserCertificate(
      id: doc.id,
      userId: data['userId'] ?? '',
      role: data['role'] ?? '',
      certName: data['certName'] ?? '',
      userName: data['userName'] ?? '',
      issueDate: data['issueDate'] ?? 'N/A',
    );
  }
}
