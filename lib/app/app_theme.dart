import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
     return ThemeData(
       brightness: .light
     );
  }
  static ThemeData get darkTheme {
     return ThemeData(
       brightness: .dark
     );
  }
}