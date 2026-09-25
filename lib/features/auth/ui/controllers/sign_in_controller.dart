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
     String? accessToken = data['token'] ?? (data['data'] != null ? data['data']['token'] : null);
     UserModel? userModel;
     if (data['data'] != null) {
       userModel = UserModel.fromJson(data['data']);
     } else {
       userModel = UserModel.fromJson(data);
     }
     if (accessToken != null) {
       await AuthController.saveUserData(accessToken, userModel);
       isSuccess = true;
       _errorMessage = null;
     } else {
       _errorMessage = 'Invalid response: token not found';
     }
   }else{
     _errorMessage = response.errorMessage;
   }
   _inProgress = false;
   update();
   return isSuccess;

  }
}