import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:get/get.dart';

import '../features/auth/ui/controllers/sign_up_controller.dart';
import '../features/common/controller/main_bottom_nav_bar_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(MainBottomNavBarController());
    Get.put(NetworkCaller());
    Get.put(SignUpController());
  }

}