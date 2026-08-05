class SignUpModel {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;
  final String address;


  SignUpModel(
      {required this.firstName, required this.lastName, required this.phone, required this.email, required this.password, required this.address});

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "phone": phone,
      "email": email,
      "password": password,
      "city": address
    };
  }
}