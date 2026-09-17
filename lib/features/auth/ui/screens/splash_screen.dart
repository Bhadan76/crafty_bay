import 'package:crafty_bay/features/common/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
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
    // final user = FirebaseAuth.instance.currentUser;

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


