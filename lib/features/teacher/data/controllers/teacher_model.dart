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

  final String? group;

  final String level;
  final String xp;

  TeacherModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileImage,
    this.phone,
    this.dob,
    this.address,
    this.resumeLink,
    this.group,
    required this.level,
    required this.xp,
  });

  String get fullName => "$firstName $lastName".trim();

  String? get imageUrl => profileImage;

  factory TeacherModel.fromMap(Map<String, dynamic> data) {
    return TeacherModel(
      uid: data['uid']?.toString() ?? "",
      firstName: data['firstName']?.toString() ?? "",
      lastName: data['lastName']?.toString() ?? "",
      email: data['email']?.toString() ?? "",
      profileImage: data['profileImage']?.toString(),

      phone: data['phone']?.toString(),
      dob: data['dob']?.toString(),
      address: data['address']?.toString(),
      resumeLink: data['resumeLink']?.toString(),
      group: data['group']?.toString(),

      level:
          (data['xpLevel'] is int)
              ? data['xpLevel'].toString()
              : int.tryParse(data['xpLevel']?.toString() ?? "0")!.toString(),

      xp: data['xp']?.toString() ?? "0 XP",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "profileImage": profileImage,
      "phone": phone,
      "dob": dob,
      "address": address,
      "resumeLink": resumeLink,
      "group": group,

      "xpLevel": level,
      "xp": xp,
    };
  }
}
