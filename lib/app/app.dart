
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../features/auth/ui/screens/splash_screen.dart';
import '../l10n/app_localizations.dart';
import 'app_colors.dart';
import 'app_routes.dart';
import 'app_theme.dart';
import 'controller_binder.dart';

class CraftyBayApp extends StatefulWidget {
  const CraftyBayApp({super.key});

  @override
  State<CraftyBayApp> createState() => _CraftyBayAppState();
}

class _CraftyBayAppState extends State<CraftyBayApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialBinding: ControllerBinder(),
          title: 'Crafty Bay',
          initialRoute: SplashScreen.name,
          getPages: AppRoutes.getPages,
          theme: ThemeData(
              colorSchemeSeed: AppColors.primary,
              scaffoldBackgroundColor: Colors.white,
              textTheme: const TextTheme(
                titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  fixedSize: const Size(double.maxFinite, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: Colors.white,
                ),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
              )
          ),
          //light theme
          //dark theme
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          //Localizations
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('bn'),
          supportedLocales: const [
            Locale('en'), // English
            Locale('bn'), // Bengali
          ],
        );
      },
    );
  }
}
