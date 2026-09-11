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
     final data = response.responseData;
     String? accessToken;
     UserModel? userModel;
     
     if (data['token'] != null) {
       accessToken = data['token'];
       userModel = UserModel.fromJson(data['data'] ?? {});
     } else if (data['data'] != null && data['data'] is Map) {
       accessToken = data['data']['token'];
       userModel = UserModel.fromJson(data['data']['user'] ?? data['data']);
     }

     if (accessToken != null && userModel != null) {
       await AuthController.saveUserData(accessToken, userModel);
       isSuccess = true;
       _errorMessage = null;
     } else {
       _errorMessage = 'Invalid response format';
     }
   }else{
     _errorMessage = response.errorMessage;
   }
   _inProgress = false;
   update();
   return isSuccess;

  }
}