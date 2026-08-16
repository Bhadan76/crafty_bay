
import 'package:crafty_bay/features/auth/ui/controllers/auth_controller.dart';
import 'package:crafty_bay/features/auth/ui/screens/sign_in_screen.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:logger/logger.dart';

part 'network_response.dart';

class NetworkCaller {
  final Logger _logger = Logger();
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  static void onUnauthorized() {
    AuthController.clearUserData();
    Get.offAllNamed(SignInScreen.name);
  }

  NetworkCaller() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AuthController.token;
          if (token != null && token.isNotEmpty) {
            options.headers['token'] = token;
          }
          _logger.i('Token => $token');
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i('Response => ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            onUnauthorized();
          }
          handler.next(error);
        },
      ),
    );
  }

  // ================= GET =================

  Future<NetworkResponse> getRequest({required String url, Map<String, dynamic>? queryParameters}) async {
    try {
      final Response response = await _dio.get(url, queryParameters: queryParameters);
      _logResponse(response.statusCode ?? 0, response);

      return NetworkResponse(
        isSuccess: true,
        responseData: response.data,
        responseCode: response.statusCode!,
        errorMessage: (response.data is Map) ? response.data['message'] : null,
      );
    } on DioException catch (e) {
      _logger.e(e.toString());

      String? errorMessage;
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'];
      }

      return NetworkResponse(
        isSuccess: false,
        responseData: e.response?.data,
        responseCode: e.response?.statusCode ?? -1,
        errorMessage: errorMessage ?? e.message ?? 'Something went wrong',
      );
    }
  }

  // ================= POST =================

  Future<NetworkResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Response response = await _dio.post(url, data: body);
      _logResponse(response.statusCode ?? 0, response);

      return NetworkResponse(
        isSuccess: true,
        responseData: response.data,
        responseCode: response.statusCode!,
        errorMessage: (response.data is Map) ? response.data['message'] : null,
      );
    } on DioException catch (e) {
      _logger.e(e.toString());

      String? errorMessage;
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'];
      }

      return NetworkResponse(
        isSuccess: false,
        responseData: e.response?.data,
        responseCode: e.response?.statusCode ?? -1,
        errorMessage: errorMessage ?? e.message ?? 'Something went wrong',
      );
    }
  }

  // ================= RESPONSE LOG =================

  void _logResponse(int statusCode, Response response) {
    _logger.i(
      'Status Code => $statusCode\n'
      'Response Body => ${response.data}',
    );
  }
}
