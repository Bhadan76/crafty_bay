import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/auth/data/models/otp_verify_model.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';


class OtpVerifyController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;


  Future<bool> otpVerify(OtpVerifyModel otpVerifyModel) async{
   bool isSuccess = false;
   _inProgress = true;
   update();
   final NetworkResponse response = await Get.find<NetworkCaller>().postRequest(url: AppUrls.otpVerifyUrl,body: otpVerifyModel.toJson());
   if(response.isSuccess){
      final token = response.responseData['data'];
      await AuthController().saveAccessToken(token);
      isSuccess = true;
      _errorMessage = null;
   }else{
     _errorMessage = response.errorMessage;
   }
   _inProgress = false;
   update();
   return isSuccess;

  }
}