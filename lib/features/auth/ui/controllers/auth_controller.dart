import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';

class AuthController  {
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';

  static String? token;
  static UserModel? user;

  Future<void> saveUserData(String accessToken, UserModel userModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    await prefs.setString(_userKey, jsonEncode(userModel.toJson()));

    token = accessToken;
    user = userModel;

  }

  Future<void> saveAccessToken(String t) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, t);
    token = t;

  }

  static Future<void> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString(_tokenKey);
    final String? userJson = prefs.getString(_userKey);
    if (userJson != null) {
      user = UserModel.fromJson(jsonDecode(userJson));
    }
  }

  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString(_tokenKey);
    if (token != null) {
      await getUserData();
      return true;
    }
    return false;
  }

  static Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    token = null;
    user = null;
  }
}
