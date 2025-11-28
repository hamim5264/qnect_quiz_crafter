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
      uid: data['uid']?.toString() ?? "",
      firstName: data['firstName']?.toString() ?? "",
      lastName: data['lastName']?.toString() ?? "",
      email: data['email']?.toString() ?? "",
      profileImage: data['profileImage']?.toString(),

      phone: data['phone']?.toString(),
      dob: data['dob']?.toString(),
      address: data['address']?.toString(),
      group: data['group']?.toString(),

      level: data['level']?.toString() ?? "Level 00",
      xp: data['xp']?.toString() ?? "0 XP",
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
