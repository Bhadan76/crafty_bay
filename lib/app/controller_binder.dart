import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/cart/ui/controller/cart_item_controller.dart';
import 'package:crafty_bay/features/common/controllers/category_controller.dart';
import 'package:crafty_bay/features/common/controllers/slider_controller.dart';
import 'package:crafty_bay/features/products/ui/controller/product_by_remark_controller.dart';
import 'package:crafty_bay/features/wish_list/ui/controller/wish_list_controller.dart';
import 'package:get/get.dart';

import '../features/auth/ui/controllers/auth_controller.dart';
import '../features/auth/ui/controllers/otp_verify_controller.dart';
import '../features/auth/ui/controllers/sign_in_controller.dart';
import '../features/auth/ui/controllers/sign_up_controller.dart';
import '../features/common/controllers/add_to_cart_controller.dart';
import '../features/common/controllers/main_bottom_nav_bar_controller.dart';
import '../features/products/ui/controller/product_details_controller.dart';
import '../features/products/ui/controller/product_list_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(MainBottomNavBarController());
    Get.put(CategoryController());
    Get.put(NetworkCaller());
    Get.put(AuthController());
    Get.put(SliderController());
    Get.put(SignUpController());
    Get.put(SignInController());
    Get.lazyPut(()=>OtpVerifyController());
    Get.put(ProductListController());
    Get.put(AddToCartController());
    Get.put(CartItemController());
    Get.put(WishListController());
    Get.put(ProductDetailsController());
    Get.put(ProductByRemarkController());
  }
}
