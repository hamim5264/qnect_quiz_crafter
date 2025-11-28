class TeacherModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String? profileImage;

  final String? phone;
  final String? dob;
  final String? address;
  final String? resumeLink;

  final int level;
  final int xp;

  TeacherModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImage,
    this.phone,
    this.dob,
    this.address,
    this.resumeLink,
    this.level = 0,
    this.xp = 0,
  });

  String get fullName {
    if (firstName.isEmpty && lastName.isEmpty) return "Teacher";
    if (firstName.isEmpty) return lastName;
    if (lastName.isEmpty) return firstName;
    return "$firstName $lastName";
  }

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profileImage'],
      phone: map['phone'],
      dob: map['dob'],
      address: map['address'],
      resumeLink: map['resumeLink'],
      level: map['level'] ?? 0,
      xp: map['xp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profileImage': profileImage,
      'phone': phone,
      'dob': dob,
      'address': address,
      'resumeLink': resumeLink,
      'level': level,
      'xp': xp,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  TeacherModel copyWith({
    String? firstName,
    String? lastName,
    String? profileImage,
    String? phone,
    String? dob,
    String? address,
    String? resumeLink,
  }) {
    return TeacherModel(
      uid: uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email,
      profileImage: profileImage ?? this.profileImage,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      address: address ?? this.address,
      resumeLink: resumeLink ?? this.resumeLink,
      level: level,
      xp: xp,
    );
  }
}
