import 'package:crafty_bay/features/cart/ui/screens/cart_screen.dart';
import 'package:crafty_bay/features/cart/ui/screens/payment_gateway_screen.dart';
import 'package:crafty_bay/features/common/data/model/category_model.dart';
import 'package:crafty_bay/features/common/ui/screens/search_screen.dart';
import 'package:crafty_bay/features/profile/ui/screen/profile_screen.dart';
import 'package:crafty_bay/features/products/ui/screens/product_list.dart';
import 'package:crafty_bay/features/products/ui/screens/product_list_details.dart';
import 'package:crafty_bay/features/common/ui/screens/notification_screen.dart';
import 'package:crafty_bay/features/profile/ui/screen/my_orders_screen.dart';
import 'package:flutter/material.dart';

import '../features/auth/ui/screens/otp_verify_screen.dart';
import '../features/auth/ui/screens/sign_in_screen.dart';
import '../features/auth/ui/screens/sign_up_screen.dart';
import '../features/auth/ui/screens/splash_screen.dart';
import '../features/common/ui/screens/main_bottom_nav_bar_screen.dart';
import '../features/reviews/ui/screen/create_reviews_screen.dart';
import 'package:get/get.dart';

import 'package:crafty_bay/features/home/ui/screens/customer_care_chat_screen.dart';

import 'package:crafty_bay/features/admin/ui/screens/admin_dashboard_screen.dart';

class AppRoutes {
  static List<GetPage> getPages = [
    GetPage(name: SplashScreen.name, page: () => const SplashScreen()),
    GetPage(name: SignInScreen.name, page: () => const SignInScreen()),
    GetPage(name: CartScreen.name, page: () => const CartScreen()),
    GetPage(name: SignUpScreen.name, page: () => const SignUpScreen()),
    GetPage(
      name: OtpVerifyScreen.name,
      page: () {
        final String email = Get.arguments ?? '';
        return OtpVerifyScreen(email: email);
      },
    ),
    GetPage(
      name: MainBottomNavBarScreen.name,
      page: () => const MainBottomNavBarScreen(),
    ),
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
        final String productId = Get.arguments as String;
        return ProductListDetails(productId: productId);
      },
    ),
    GetPage(
      name: PaymentGatewayScreen.name,
      page: () {
        final double totalAmount = Get.arguments as double;
        return PaymentGatewayScreen(totalAmount: totalAmount);
      },
    ),
    GetPage(name: SearchScreen.name, page: () => const SearchScreen()),
    GetPage(name: ProfileScreen.name, page: () => const ProfileScreen()),
    GetPage(
      name: CustomerCareChatScreen.name,
      page: () => const CustomerCareChatScreen(),
    ),
    GetPage(name: NotificationScreen.name, page: () => const NotificationScreen()),
    GetPage(name: MyOrdersScreen.name, page: () => const MyOrdersScreen()),
    GetPage(name: AdminDashboardScreen.name, page: () => const AdminDashboardScreen()),
  ];

  static Route<dynamic> routes(RouteSettings settings) {
    Widget route = const SizedBox();

    if (settings.name == SplashScreen.name) {
      route = const SplashScreen();
    } else if (settings.name == SignInScreen.name) {
      route = const SignInScreen();
    } else if (settings.name == CartScreen.name) {
      route = const CartScreen();
    } else if (settings.name == SignUpScreen.name) {
      route = const SignUpScreen();
    } else if (settings.name == OtpVerifyScreen.name) {
      final String email = (settings.arguments is String)
          ? settings.arguments as String
          : '';
      route = OtpVerifyScreen(email: email);
    } else if (settings.name == MainBottomNavBarScreen.name) {
      route = const MainBottomNavBarScreen();
    } else if (settings.name == ProductList.name) {
      final CategoryModel category = settings.arguments as CategoryModel;
      route = ProductList(categoryId: category.id, categoryName: category.name);
    } else if (settings.name == ProductListDetails.name) {
      final String productId = (settings.arguments is String)
          ? settings.arguments as String
          : '';
      route = ProductListDetails(productId: productId);
    } else if (settings.name == CreateReviewsScreen.name) {
      final dynamic args = settings.arguments;
      if (args is Map<String, dynamic>) {
        route = CreateReviewsScreen(
          productId: args['productId'],
          productTitle: args['productTitle'],
          productImage: args['productImage'],
        );
      } else if (args is String) {
        route = CreateReviewsScreen(productId: args);
      } else {
        route = const CreateReviewsScreen();
      }

    } else if (settings.name == PaymentGatewayScreen.name) {
      final double totalAmount = (settings.arguments is double)
          ? settings.arguments as double
          : 0.0;
      route = PaymentGatewayScreen(totalAmount: totalAmount);
    } else if (settings.name == SearchScreen.name) {
      route = const SearchScreen();
    } else if (settings.name == ProfileScreen.name) {
      route = const ProfileScreen();
    } else if (settings.name == CustomerCareChatScreen.name) {
      route = const CustomerCareChatScreen();
    } else if (settings.name == NotificationScreen.name) {
      route = const NotificationScreen();
    } else if (settings.name == MyOrdersScreen.name) {
      route = const MyOrdersScreen();
    } else if (settings.name == AdminDashboardScreen.name) {
      route = const AdminDashboardScreen();
    } else {
      route = Scaffold(
        body: Center(child: Text('Route not found: ${settings.name}')),
      );
    }

    return MaterialPageRoute(builder: (ctx) => route);
  }
}
