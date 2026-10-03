import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/auth/data/models/user_model.dart';
import 'package:get/get.dart';

import '../../data/models/sign_in_model.dart';
import 'auth_controller.dart';

class SignInController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(SignInModel signInModel) async {
    _inProgress = true;
    _errorMessage = null;
    update();

    try {
      final networkCaller = Get.find<NetworkCaller>();

      // The dedicated admin endpoint is tried first. A successful response
      // from this endpoint is authoritative for the account's admin role.
      final NetworkResponse adminResponse = await networkCaller.postRequest(
        url: AppUrls.adminSignInUrl,
        body: signInModel.toJson(),
      );
      if (await _saveLoginResponse(adminResponse)) {
        return true;
      }

      // Non-admin accounts authenticate through the existing customer API.
      final NetworkResponse userResponse = await networkCaller.postRequest(
        url: AppUrls.signInUrl,
        body: signInModel.toJson(),
      );
      if (await _saveLoginResponse(userResponse)) {
        return true;
      }

      _errorMessage = userResponse.errorMessage ??
          adminResponse.errorMessage ??
          'Sign in failed';
      return false;
    } catch (e) {
      _errorMessage = 'Sign in failed: $e';
      return false;
    } finally {
      _inProgress = false;
      update();
    }
  }

  Future<bool> _saveLoginResponse(
    NetworkResponse response,
  ) async {
    if (!response.isSuccess || response.responseData is! Map) return false;

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(response.responseData as Map);
    final Map<String, dynamic> userJson = _findAccount(data) ?? data;
    final String? accessToken = _findString(
      data,
      const {'token', 'accessToken', 'access_token'},
    );
    if (accessToken == null || accessToken.trim().isEmpty) return false;

    // The API role determines where sign-in sends the account. Require it so
    // an omitted role cannot silently turn an admin login into a user login.
    final String? role = userJson['role']?.toString() ??
        _findString(data, const {'role'});
    if (role == null || role.trim().isEmpty) return false;
    userJson['role'] = role;

    await AuthController.saveUserData(
      accessToken,
      UserModel.fromJson(userJson),
    );
    return true;
  }

  Map<String, dynamic>? _findAccount(Map<String, dynamic> value) {
    const accountKeys = {'user', 'admin', 'account', 'profile'};
    for (final entry in value.entries) {
      if (accountKeys.contains(entry.key.toLowerCase()) && entry.value is Map) {
        return Map<String, dynamic>.from(entry.value as Map);
      }
    }

    for (final entry in value.entries) {
      if (_envelopeKeys.contains(entry.key.toLowerCase()) && entry.value is Map) {
        final result = _findAccount(Map<String, dynamic>.from(entry.value as Map));
        if (result != null) return result;
      }
    }

    // Some API versions return the account object directly in `data`.
    if (value.keys.any((key) => const {'_id', 'id', 'uid', 'email'}.contains(key))) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  String? _findString(Map<String, dynamic> value, Set<String> keys) {
    for (final entry in value.entries) {
      if (keys.contains(entry.key) && entry.value != null) {
        final result = entry.value.toString();
        if (result.isNotEmpty) return result;
      }
    }

    for (final entry in value.entries) {
      if (_envelopeKeys.contains(entry.key.toLowerCase()) && entry.value is Map) {
        final result = _findString(
          Map<String, dynamic>.from(entry.value as Map),
          keys,
        );
        if (result != null) return result;
      }
    }
    return null;
  }

  static const Set<String> _envelopeKeys = {'data', 'result', 'payload'};
}
