class SignUpModel {
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;
  final String password;
  final String address;


  SignUpModel(
      {required this.firstName, required this.lastName, required this.email, required this.password, required this.address, required this.mobile});

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "mobile": mobile,
      "city": address,
      "shippingAddress": address
    };
  }
}
