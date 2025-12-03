import 'package:cloud_firestore/cloud_firestore.dart';

enum CourseStatus { draft, pending, approved, rejected }

class CourseModel {
  final String id;
  final String teacherId;
  final String title;
  final String description;
  final int price;
  final String group;
  final String level;
  final String remark;
  final String iconPath;
  final DateTime startDate;
  final DateTime endDate;

  final int discountPercent;
  final bool discountActive;
  final int totalPrice;

  final CourseStatus status;
  final String? rejectionReason;

  final int quizzesCount;
  final int enrolledCount;
  final int soldCount;
  final int totalDurationSeconds;

  final DateTime createdAt;
  final DateTime updatedAt;

  const CourseModel({
    required this.id,
    required this.teacherId,
    required this.title,
    required this.description,
    required this.price,
    required this.group,
    required this.level,
    required this.remark,
    required this.iconPath,
    required this.startDate,
    required this.endDate,
    required this.discountPercent,
    required this.discountActive,
    required this.totalPrice,
    required this.status,
    required this.rejectionReason,
    required this.quizzesCount,
    required this.enrolledCount,
    required this.soldCount,
    required this.totalDurationSeconds,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isEditable => status != CourseStatus.approved;

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
      'discountActive': discountActive,
      'totalPrice': totalPrice,
      'status': status.name,
      'rejectionReason': rejectionReason,
      'quizzesCount': quizzesCount,
      'enrolledCount': enrolledCount,
      'soldCount': soldCount,
      'totalDurationSeconds': totalDurationSeconds,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory CourseModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: doc.id,
      teacherId: data['teacherId'] as String,
      title: data['title'] as String,
      description: data['description'] as String? ?? '',
      price: data['price'] as int? ?? 0,
      group: data['group'] as String? ?? 'All',
      level: data['level'] as String? ?? '',
      remark: data['remark'] as String? ?? '',
      iconPath: data['iconPath'] as String? ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      discountPercent: data['discountPercent'] as int? ?? 0,
      discountActive: data['discountActive'] as bool? ?? false,
      totalPrice: data['totalPrice'] as int? ?? 0,
      status: _statusFromString(data['status'] as String?),
      rejectionReason: data['rejectionReason'] as String?,
      quizzesCount: data['quizzesCount'] as int? ?? 0,
      enrolledCount: data['enrolledCount'] as int? ?? 0,
      soldCount: data['soldCount'] as int? ?? 0,
      totalDurationSeconds: data['totalDurationSeconds'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  static CourseStatus _statusFromString(String? s) {
    switch (s) {
      case 'pending':
        return CourseStatus.pending;
      case 'approved':
        return CourseStatus.approved;
      case 'rejected':
        return CourseStatus.rejected;
      case 'draft':
      default:
        return CourseStatus.draft;
    }
  }

  CourseModel copyWith({
    String? id,
    String? teacherId,
    String? title,
    String? description,
    int? price,
    String? group,
    String? level,
    String? remark,
    String? iconPath,
    DateTime? startDate,
    DateTime? endDate,
    int? discountPercent,
    bool? discountActive,
    int? totalPrice,
    CourseStatus? status,
    String? rejectionReason,
    int? quizzesCount,
    int? enrolledCount,
    int? soldCount,
    int? totalDurationSeconds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      group: group ?? this.group,
      level: level ?? this.level,
      remark: remark ?? this.remark,
      iconPath: iconPath ?? this.iconPath,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      discountPercent: discountPercent ?? this.discountPercent,
      discountActive: discountActive ?? this.discountActive,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      quizzesCount: quizzesCount ?? this.quizzesCount,
      enrolledCount: enrolledCount ?? this.enrolledCount,
      soldCount: soldCount ?? this.soldCount,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
