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
  final int quizCount;          // ⭐ NEW FIELD
  final DateTime createdAt;
  final DateTime updatedAt;

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
    required this.quizCount,     // ⭐ NEW FIELD
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeacherCourseModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime _parse(String? v, {DateTime? fallback}) {
      if (v == null || v.isEmpty) return fallback ?? DateTime.now();
      return DateTime.tryParse(v) ?? (fallback ?? DateTime.now());
    }

    return TeacherCourseModel(
      id: doc.id,
      teacherId: data['teacherId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      group: data['group'] ?? '',
      level: data['level'] ?? '',
      remark: data['remark'],
      iconPath: data['iconPath'] ?? '',
      startDate: _parse(data['startDate'] as String?),
      endDate: _parse(data['endDate'] as String?,
          fallback: DateTime.now().add(const Duration(days: 60))),
      discountPercent: data['discountPercent'] ?? 0,
      applyDiscount: data['applyDiscount'] ?? false,
      status: _statusFromString(data['status']),
      quizCount: data['quizCount'] ?? 0,   // ⭐ NEW
      createdAt: _parse(data['createdAt'] as String?),
      updatedAt: _parse(data['updatedAt'] as String?),
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
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'discountPercent': discountPercent,
      'applyDiscount': applyDiscount,
      'status': status.name,
      'quizCount': quizCount,     // ⭐ NEW
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static CourseStatus _statusFromString(String? v) {
    switch (v) {
      case 'pending':
        return CourseStatus.pending;
      case 'approved':
        return CourseStatus.approved;
      case 'rejected':
        return CourseStatus.rejected;
      default:
        return CourseStatus.draft;
    }
  }
}
