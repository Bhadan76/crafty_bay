class OtpVerifyModel {
  final String email;
  final String otp ;


  OtpVerifyModel({required this.otp, required this.email});


  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}

