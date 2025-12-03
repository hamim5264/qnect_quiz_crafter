import 'package:cloud_firestore/cloud_firestore.dart';

enum CourseStatus { draft, pending, approved, rejected }

class TeacherCourseModel {
  final String id;
  final String teacherId;
  final String title;
  final String description;
  final double price;
  final String group;
  final String level;
  final String? remark;
  final String iconPath;
  final DateTime startDate;
  final DateTime endDate;
  final int discountPercent;
  final bool applyDiscount;
  final CourseStatus status;
  final int quizCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int enrolledCount;

  TeacherCourseModel({
    required this.id,
    required this.teacherId,
    required this.title,
    required this.description,
    required this.price,
    required this.group,
    required this.level,
    this.remark,
    required this.iconPath,
    required this.startDate,
    required this.endDate,
    required this.discountPercent,
    required this.applyDiscount,
    required this.status,
    required this.quizCount,
    required this.createdAt,
    required this.updatedAt,
    required this.enrolledCount,
  });

  static DateTime _parseDate(dynamic value, {DateTime? fallback}) {
    if (value == null) return fallback ?? DateTime.now();

    if (value is Timestamp) return value.toDate();

    if (value is String) {
      return DateTime.tryParse(value) ?? (fallback ?? DateTime.now());
    }

    return fallback ?? DateTime.now();
  }

  factory TeacherCourseModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return TeacherCourseModel(
      id: doc.id,
      teacherId: data['teacherId']?.toString() ?? '',

      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      price: (data['price'] ?? 0).toDouble(),

      group: data['group']?.toString() ?? '',
      level: data['level']?.toString() ?? '',
      remark: data['remark']?.toString(),

      iconPath: data['iconPath']?.toString() ?? '',

      startDate: _parseDate(data['startDate']),
      endDate: _parseDate(
        data['endDate'],
        fallback: DateTime.now().add(const Duration(days: 60)),
      ),

      discountPercent: data['discountPercent'] ?? 0,
      applyDiscount: data['applyDiscount'] ?? false,

      status: _statusFromString(data['status']?.toString()),

      quizCount: data['quizCount'] ?? 0,
      enrolledCount: data['enrolledCount'] ?? 0,

      createdAt: _parseDate(data['createdAt']),
      updatedAt: _parseDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacherId': teacherId,
      'title': title,
      'description': description,
      'price': price,
      'group': group,
      'level': level,
      'remark': remark,
      'iconPath': iconPath,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'discountPercent': discountPercent,
      'applyDiscount': applyDiscount,
      'status': status.name,
      'quizCount': quizCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'enrolledCount': enrolledCount,
    };
  }

  static CourseStatus _statusFromString(String? v) {
    final value = (v ?? "").toLowerCase().trim();

    switch (value) {
      case 'pending':
        return CourseStatus.pending;
      case 'approved':
        return CourseStatus.approved;
      case 'rejected':
        return CourseStatus.rejected;
      case 'draft':
        return CourseStatus.draft;
      default:
        return CourseStatus.draft;
    }
  }
}
