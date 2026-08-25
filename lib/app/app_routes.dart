import 'package:crafty_bay/features/common/data/model/category_model.dart';
import 'package:crafty_bay/features/products/ui/screens/product_list.dart';
import 'package:crafty_bay/features/products/ui/screens/product_list_details.dart';
import 'package:flutter/material.dart';

import '../features/auth/ui/screens/otpVerify_screen.dart';
import '../features/auth/ui/screens/sign_in_screen.dart';
import '../features/auth/ui/screens/sign_up_screen.dart';
import '../features/auth/ui/screens/splash_screen.dart';
import '../features/common/ui/screens/main_bottom_nav_bar_screen.dart';
import '../features/reviews/ui/screen/create_reviews_screen.dart';
import '../features/reviews/ui/screen/reviews_screen.dart';

import 'package:get/get.dart';

class AppRoutes {
  static List<GetPage> getPages = [
    GetPage(name: SplashScreen.name, page: () => const SplashScreen()),
    GetPage(name: SignInScreen.name, page: () => const SignInScreen()),
    GetPage(name: SignUpScreen.name, page: () => const SignUpScreen()),
    GetPage(
      name: OtpVerifyScreen.name,
      page: () {
        final String email = Get.arguments ?? '';
        return OtpVerifyScreen(email: email);
      },
    ),
    GetPage(name: MainBottomNavBarScreen.name, page: () => const MainBottomNavBarScreen()),
    GetPage(
      name: ProductList.name,
      page: () {
        final CategoryModel category = Get.arguments as CategoryModel;
        return ProductList(
          categoryId: category.id,
          categoryName: category.name,
        );
      },
    ),
    GetPage(
        name: ProductListDetails.name,
        page: () {
        final String productId =  Get.arguments as String;
          return ProductListDetails(productId: productId,);
        }
    ),
    GetPage(name: ReviewsScreen.name, page: () => const ReviewsScreen()),
    GetPage(name: CreateReviewsScreen.name, page: () => const CreateReviewsScreen()),
  ];

  static Route<dynamic> routes(RouteSettings settings) {
    Widget route = const SizedBox();

    if (settings.name == SplashScreen.name) {
      route = const SplashScreen();
    } else if (settings.name == SignInScreen.name) {
      route = const SignInScreen();
    } else if (settings.name == SignUpScreen.name) {
      route = const SignUpScreen();
    } else if (settings.name == OtpVerifyScreen.name) {
      final String email = (settings.arguments is String) ? settings.arguments as String : '';
      route = OtpVerifyScreen(email: email);
    } else if (settings.name == MainBottomNavBarScreen.name) {
      route = const MainBottomNavBarScreen();
    } else if (settings.name == ProductList.name) {
      final CategoryModel category = settings.arguments as CategoryModel;
      route = ProductList(
        categoryId: category.id,
        categoryName: category.name,
      );
    } else if (settings.name == ProductListDetails.name) {
      final String productId = (settings.arguments is String) ? settings.arguments as String : '';
      route = ProductListDetails(productId: productId,);
    } else if (settings.name == ReviewsScreen.name) {
      route = const ReviewsScreen();
    } else if (settings.name == CreateReviewsScreen.name) {
      route = const CreateReviewsScreen();
    } else {
      route = Scaffold(
        body: Center(
          child: Text('Route not found: ${settings.name}'),
        ),
      );
    }

    return MaterialPageRoute(builder: (ctx) => route);
  }
}




