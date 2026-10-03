class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String city;
  final String? photo;
  final String role;

  String get fullName {
    return '$firstName $lastName';
  }

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.city,
    this.photo,
    this.role = 'user',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['_id'] ?? json['id'] ?? json['uid'] ?? '').toString(),
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: (json['email'] ?? '').toString(),
      mobile: (json['mobile'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      photo: (json['photo'] ?? json['photoURL'] ?? json['picture'])?.toString(),
      role: (json['role'] ?? 'user').toString(),
    );
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? city,
    String? photo,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      city: city ?? this.city,
      photo: photo ?? this.photo,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobile': mobile,
      'city': city,
      'photo': photo,
      'role': role,
    };
  }
}
