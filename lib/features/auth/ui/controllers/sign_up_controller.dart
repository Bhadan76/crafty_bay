import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/auth/data/models/sign_up_model.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class SignUpController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> signUp(SignUpModel signUpModel) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkCaller>()
        .postRequest(url: AppUrls.signUpUrl, body: signUpModel.toJson());
    if (response.isSuccess) {
      // ✅ Backend থেকে আসা token সেভ করুন
      final String? token =
          response.responseData['token'] ??
          response.responseData['data']?['token'];
      if (token != null) {
        await AuthController.saveAccessToken(token);
      }
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
