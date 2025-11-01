import 'package:equatable/equatable.dart';

enum SignUpRole { student, teacher }

class SignUpState extends Equatable {
  final SignUpRole role;
  final int step;
  final bool loading;

  final String firstName;
  final String lastName;
  final String email;
  final DateTime? dob;
  final String phone;
  final String address;

  final String level;
  final String group;

  final String resumeLink;

  const SignUpState({
    this.role = SignUpRole.student,
    this.step = 0,
    this.loading = false,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.dob,
    this.phone = '',
    this.address = '',
    this.level = '',
    this.group = '',
    this.resumeLink = '',
  });

  SignUpState copyWith({
    SignUpRole? role,
    int? step,
    bool? loading,
    String? firstName,
    String? lastName,
    String? email,
    DateTime? dob,
    String? phone,
    String? address,
    String? level,
    String? group,
    String? resumeLink,
  }) {
    return SignUpState(
      role: role ?? this.role,
      step: step ?? this.step,
      loading: loading ?? this.loading,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      level: level ?? this.level,
      group: group ?? this.group,
      resumeLink: resumeLink ?? this.resumeLink,
    );
  }

  @override
  List<Object?> get props => [
    role,
    step,
    loading,
    firstName,
    lastName,
    email,
    dob,
    phone,
    address,
    level,
    group,
    resumeLink,
  ];
}
