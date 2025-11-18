class AdminModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;

  final String profileImage;

  AdminModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImage,
  });

  String get fullName => "$firstName $lastName".trim();

  String get imageUrl => profileImage;

  factory AdminModel.fromMap(Map<String, dynamic> data) {
    return AdminModel(
      uid: data['uid'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      profileImage: (data['profileImage'] ?? "").toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "profileImage": profileImage,
    };
  }
}
