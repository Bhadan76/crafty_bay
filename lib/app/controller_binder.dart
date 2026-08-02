import 'package:get/get.dart';

import '../features/common/controller/main_bottom_nav_bar_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(MainBottomNavBarController());
  }

}