import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/common/controllers/slider_controller.dart';
import 'package:get/get.dart';

import '../features/auth/ui/controllers/auth_controller.dart';
import '../features/auth/ui/controllers/otp_verify_controller.dart';
import '../features/auth/ui/controllers/sign_in_controller.dart';
import '../features/auth/ui/controllers/sign_up_controller.dart';
import '../features/common/controllers/main_bottom_nav_bar_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(MainBottomNavBarController());
    Get.put(NetworkCaller());
    Get.put(AuthController());
    Get.put(SliderController());
    Get.put(SignUpController());
    Get.put(SignInController());
    Get.lazyPut(()=>OtpVerifyController());

  }

}