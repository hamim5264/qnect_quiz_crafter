import 'package:equatable/equatable.dart';
import '../../../course_management/data/models/course_model.dart';

class TeacherCourseFormState extends Equatable {
  final String? courseId;
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
  final bool applyDiscount;
  final bool isSubmitting;
  final CourseStatus status;
  final String? errorMessage;

  TeacherCourseFormState({
    this.courseId,
    this.title = '',
    this.description = '',
    this.price = 0,
    this.group = 'Science',
    this.level = 'HSC',
    this.remark = '',
    this.iconPath = '',
    DateTime? startDate,
    DateTime? endDate,
    this.discountPercent = 0,
    this.applyDiscount = false,
    this.isSubmitting = false,
    this.status = CourseStatus.draft,
    this.errorMessage,
  }) : startDate = startDate ?? DateTime.now(),
       endDate = endDate ?? DateTime.now().add(const Duration(days: 60));

  int get totalPrice {
    if (!applyDiscount) return price;
    return price - (price * discountPercent ~/ 100);
  }

  bool get isEdit => courseId != null;

  bool get canSubmit {
    if (isSubmitting) return false;
    if (title.trim().isEmpty) return false;
    if (price <= 0) return false;
    if (startDate.isAfter(endDate)) return false;
    // cannot edit if approved
    if (isEdit && status == CourseStatus.approved) return false;
    return true;
  }

  TeacherCourseFormState copyWith({
    String? courseId,
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
    bool? applyDiscount,
    bool? isSubmitting,
    CourseStatus? status,
    String? errorMessage,
  }) {
    return TeacherCourseFormState(
      courseId: courseId ?? this.courseId,
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
      applyDiscount: applyDiscount ?? this.applyDiscount,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    courseId,
    title,
    description,
    price,
    group,
    level,
    remark,
    iconPath,
    startDate,
    endDate,
    discountPercent,
    applyDiscount,
    isSubmitting,
    status,
    errorMessage,
  ];
}
