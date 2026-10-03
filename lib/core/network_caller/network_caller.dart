import 'package:crafty_bay/features/auth/ui/controllers/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

part 'network_response.dart';

class NetworkCaller {
  final Logger _logger = Logger();
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 180),
      receiveTimeout: const Duration(seconds: 180),
      sendTimeout: const Duration(seconds: 180),
    ),
  );

  /// Called when the backend returns 401. Clears the session when the
  /// token has been expired or revoked by the server.
  static void onUnauthorized() {
    AuthController.clearUserData();
  }

  NetworkCaller() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AuthController.token;
          if (token != null && token.isNotEmpty) {
            options.headers['token'] = token;
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            final String path = error.requestOptions.path;
            final bool isAuthRoute = path.endsWith('/Login') ||
                path.endsWith('/UserLogin') ||
                path.endsWith('/Signup') ||
                path.endsWith('/VerifyOtp');
            final bool isAdminRoute = path.contains('/api/admin');
            if (!isAuthRoute && !isAdminRoute) {
              onUnauthorized();
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  // ================= GET =================

  Future<NetworkResponse> getRequest({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Dio automatically handles queryParameters correctly
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
      );
      _logResponse(response.statusCode ?? 0, response);

      return NetworkResponse(
        isSuccess: true,
        responseData: response.data,
        responseCode: response.statusCode!,
        errorMessage: (response.data is Map) ? response.data['message'] : null,
      );
    } on DioException catch (e) {
      _logError(e);

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
      _logError(e);

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

  // ================= PUT =================

  Future<NetworkResponse> putRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Response response = await _dio.put(url, data: body);
      _logResponse(response.statusCode ?? 0, response);

      return NetworkResponse(
        isSuccess: true,
        responseData: response.data,
        responseCode: response.statusCode!,
        errorMessage: (response.data is Map) ? response.data['message'] : null,
      );
    } on DioException catch (e) {
      _logError(e);

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

  // ================= PATCH =================

  Future<NetworkResponse> patchRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Response response = await _dio.patch(url, data: body);
      _logResponse(response.statusCode ?? 0, response);

      return NetworkResponse(
        isSuccess: true,
        responseData: response.data,
        responseCode: response.statusCode!,
        errorMessage: (response.data is Map) ? response.data['message'] : null,
      );
    } on DioException catch (e) {
      _logError(e);

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

  // ================= DELETE =================

  Future<NetworkResponse> deleteRequest({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        queryParameters: queryParameters,
      );
      _logResponse(response.statusCode ?? 0, response);

      return NetworkResponse(
        isSuccess: true,
        responseData: response.data,
        responseCode: response.statusCode!,
        errorMessage: (response.data is Map) ? response.data['message'] : null,
      );
    } on DioException catch (e) {
      _logError(e);

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
      'HTTP $statusCode ${response.requestOptions.method} '
      '${response.requestOptions.path}',
    );
  }

  void _logError(DioException error) {
    _logger.e(
      'HTTP request failed: ${error.requestOptions.method} '
      '${error.requestOptions.path} '
      '(status ${error.response?.statusCode ?? 'unavailable'}): '
      '${error.message ?? 'unknown error'}',
    );
  }
}
