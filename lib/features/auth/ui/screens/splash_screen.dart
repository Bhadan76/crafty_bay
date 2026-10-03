import 'package:crafty_bay/features/admin/ui/screens/admin_dashboard_screen.dart';
import 'package:crafty_bay/features/auth/ui/controllers/auth_controller.dart';
import 'package:crafty_bay/features/common/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/app_configs.dart';
import '../../../../core/extensions/localization_extension.dart';
import '../widget/app_logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String name = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    // ✅ FIX: Saved user data theke role check kori (backend is source of truth).
    // SharedPreferences-e user data save thake main() er
    // await AuthController.getUserData() call er through.
    final String role =
        (AuthController.user?.role ?? 'user').toString().trim().toLowerCase();

    if (role == 'admin') {
      Get.offAllNamed(AdminDashboardScreen.name);
      return;
    }

    Get.offAllNamed(MainBottomNavBarScreen.name);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Padding(
       padding: const EdgeInsets.all(16),
       child: Center(
         child: Column(
           children: [
             Spacer(),
             const AppLogoWidget(),
             Spacer(),
             CircularProgressIndicator(),
             SizedBox(height: 10,),
             Text('${context.localization.version} ${AppConfigs.currentAppVersion}'),
           ],
         ),
       ),
     ),
    );
  }
}


