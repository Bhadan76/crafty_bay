import 'package:crafty_bay/features/auth/ui/controllers/auth_controller.dart';
import 'package:crafty_bay/features/auth/ui/screens/sign_in_screen.dart';
import 'package:get/get.dart';

class MainBottomNavBarController extends GetxController {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void changeIndex(int index) {
    // Cart tab (index 2) এবং Wish List tab (index 3) এ login দরকার
    if ((index == 2 || index == 3) &&
        (AuthController.token == null || AuthController.token!.isEmpty)) {
      Get.toNamed(SignInScreen.name);
      return;
    }
    _selectedIndex = index;
    update();
  }

  void moveToCategory() {
    changeIndex(1);
  }

  void backToHome() {
    changeIndex(0);
  }
}