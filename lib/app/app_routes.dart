import 'package:crafty_bay/features/products/ui/screens/product_list.dart';
import 'package:crafty_bay/features/products/ui/screens/product_list_details.dart';
import 'package:flutter/material.dart';

import '../features/auth/ui/screens/otpVerify_screen.dart';
import '../features/auth/ui/screens/sign_in_screen.dart';
import '../features/auth/ui/screens/sign_up_screen.dart';
import '../features/auth/ui/screens/splash_screen.dart';
import '../features/common/ui/screens/main_bottom_nav_bar_screen.dart';

class AppRoutes {
  static Route<dynamic> routes(RouteSettings settings){
    Widget route = const SizedBox();

    if(settings.name == SplashScreen.name){
      route = const SplashScreen();
    }else if(settings.name == SignInScreen.name){
      route = const SignInScreen();
    }else if(settings.name == SignUpScreen.name){
      route = const SignUpScreen();
    }else if(settings.name == OtpVerifyScreen.name){
      route = const OtpVerifyScreen();
    }else if(settings.name == MainBottomNavBarScreen.name){
      route = const MainBottomNavBarScreen();
    }else if(settings.name == ProductList.name){
      final caregory = settings.arguments as String;
      route = ProductList(Caregory: caregory);
    }else if(settings.name == ProductListDetails.name){
      route = const ProductListDetails();
    }
    return MaterialPageRoute(builder: (ctx)=> route);
  }
}