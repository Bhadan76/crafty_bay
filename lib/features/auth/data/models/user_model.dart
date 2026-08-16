class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String city;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.city,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['_id'],
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        email: json['email'],
        mobile: json['mobile'] ?? '',
        city: json['city'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobile': mobile,
      'city': city,
    };
  }
}
