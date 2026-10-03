import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/cart/ui/controller/cart_item_controller.dart';
import 'package:crafty_bay/features/common/controllers/category_controller.dart';
import 'package:crafty_bay/features/common/controllers/slider_controller.dart';
import 'package:crafty_bay/features/products/ui/controller/product_by_remark_controller.dart';
import 'package:crafty_bay/features/cart/ui/controller/product_add_to_cart_controller.dart';
import 'package:crafty_bay/features/cart/ui/controller/remove_cart_item_controller.dart';
import 'package:crafty_bay/features/products/ui/controller/review_controller.dart';
import 'package:crafty_bay/features/wish_list/ui/controller/add_to_wish_list_controller.dart';
import 'package:crafty_bay/features/wish_list/ui/controller/wish_list_controller.dart';
import 'package:crafty_bay/features/common/controllers/notification_controller.dart';
import 'package:crafty_bay/features/profile/ui/controller/order_controller.dart';
import 'package:get/get.dart';

import '../features/auth/ui/controllers/auth_controller.dart';
import '../features/auth/ui/controllers/otp_verify_controller.dart';
import '../features/auth/ui/controllers/sign_in_controller.dart';
import '../features/auth/ui/controllers/sign_up_controller.dart';
import '../features/common/controllers/main_bottom_nav_bar_controller.dart';
import '../features/products/ui/controller/product_details_controller.dart';
import '../features/products/ui/controller/product_list_controller.dart';
import '../features/common/controllers/search_controller.dart' as custom_search;

import 'package:crafty_bay/features/admin/ui/controllers/admin_auth_controller.dart';
import 'package:crafty_bay/features/admin/ui/controllers/admin_dashboard_controller.dart';
import 'package:crafty_bay/features/admin/ui/controllers/admin_product_controller.dart';
import 'package:crafty_bay/features/admin/ui/controllers/admin_category_controller.dart';
import 'package:crafty_bay/features/admin/ui/controllers/admin_order_controller.dart';
import 'package:crafty_bay/features/admin/ui/controllers/admin_review_controller.dart';
import 'package:crafty_bay/features/admin/ui/controllers/admin_user_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkCaller(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(AdminAuthController(), permanent: true);

    Get.lazyPut(() => MainBottomNavBarController(), fenix: true);
    Get.lazyPut(() => CategoryController(), fenix: true);
    Get.lazyPut(() => AdminDashboardController(), fenix: true);
    Get.lazyPut(() => AdminProductController(), fenix: true);
    Get.lazyPut(() => AdminCategoryController(), fenix: true);
    Get.lazyPut(() => AdminOrderController(), fenix: true);
    Get.lazyPut(() => AdminReviewController(), fenix: true);
    Get.lazyPut(() => AdminUserController(), fenix: true);
    Get.lazyPut(() => SliderController(), fenix: true);
    Get.lazyPut(() => SignUpController(), fenix: true);
    Get.lazyPut(() => SignInController(), fenix: true);
    Get.lazyPut(() => OtpVerifyController(), fenix: true);
    Get.lazyPut(() => ProductListController(), fenix: true);
    Get.lazyPut(() => ProductAddToCartController(), fenix: true);
    Get.lazyPut(() => CartItemController(), fenix: true);
    Get.lazyPut(() => RemoveCartItemController(), fenix: true);
    Get.lazyPut(() => WishListController(), fenix: true);
    Get.lazyPut(() => AddToWishListController(), fenix: true);
    Get.lazyPut(() => ProductDetailsController(), fenix: true);
    Get.lazyPut(() => ProductByRemarkController(), fenix: true);
    Get.lazyPut(() => custom_search.SearchController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => ReviewController(), fenix: true);
    Get.lazyPut(() => OrderController(), fenix: true);
  }
}
