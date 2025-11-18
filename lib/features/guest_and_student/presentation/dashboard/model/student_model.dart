class StudentModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String? profileImage;

  final String? phone;
  final String? dob;
  final String? address;
  final String? group;
  final String level;
  final String xp;

  StudentModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileImage,
    this.phone,
    this.dob,
    this.address,
    this.group,
    required this.level,
    required this.xp,
  });

  String get fullName => "$firstName $lastName".trim();

  String? get imageUrl => profileImage;

  factory StudentModel.fromMap(Map<String, dynamic> data) {
    return StudentModel(
      uid: data['uid'] ?? "",
      firstName: data['firstName'] ?? "",
      lastName: data['lastName'] ?? "",
      email: data['email'] ?? "",
      profileImage: data['profileImage'],

      phone: data['phone'] ?? "",
      dob: data['dob'] ?? "",
      address: data['address'] ?? "",
      group: data['group'] ?? "",

      level: data['level'] ?? "Level 00",
      xp: data['xp'] ?? "0 XP",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "profileImage": profileImage,
      "phone": phone,
      "dob": dob,
      "address": address,
      "group": group,
      "level": level,
      "xp": xp,
    };
  }
}
