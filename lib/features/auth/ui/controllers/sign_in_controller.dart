import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/auth/data/models/user_model.dart';
import 'package:get/get.dart';

import '../../data/models/sign_in_model.dart';
import 'auth_controller.dart';

class SignInController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(SignInModel signInModel) async{
   bool isSuccess = false;
   _inProgress = true;
   update();
   final NetworkResponse response = await Get.find<NetworkCaller>().postRequest(url: AppUrls.signInUrl,body: signInModel.toJson());
   if(response.isSuccess){
      //save user token
      String accessToken = response.responseData['data']['token'];
     //user data
     UserModel userModel = response.responseData['data']['user'];
     Get.find<AuthController>().saveUserData(accessToken, userModel);
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