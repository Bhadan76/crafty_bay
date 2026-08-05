import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';

class NetworkResponse {
  final bool isSuccess;
  final dynamic responseData;
  final int responseCode;
  final String? errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.responseData,
    required this.responseCode,
    this.errorMessage = 'Something went wrong',
  });
}

class NetworkCaller {
  final Logger _logger = Logger();
  Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'token': ''
      };
      _logRequest(url, headers);
      Response response = await get(uri, headers: headers);
      _logResponse(response.statusCode, response);
      final decodedData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return NetworkResponse(isSuccess: true, responseData: decodedData, responseCode: response.statusCode,errorMessage: decodedData['message']);
      } else if (response.statusCode == 401) {
        return NetworkResponse(
          isSuccess: false,
          responseData: response.body,
          responseCode: response.statusCode,
          errorMessage: decodedData['message'],
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          responseData: response.body,
          responseCode: response.statusCode,
        );
      }
    }  catch (e) {
      return NetworkResponse(
        isSuccess: false,
        responseData: null,
        responseCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> postRequest({required String url,  Map<String,dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'token': ''
      };
      _logRequest(url, headers,body: body);
      Response response = await post(uri, headers: headers,body:jsonEncode(body));
      _logResponse(response.statusCode, response);
      final decodedData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(isSuccess: true, responseData: decodedData, responseCode: response.statusCode,errorMessage: decodedData['message']);
      } else if (response.statusCode == 401) {
        return NetworkResponse(
          isSuccess: false,
          responseData: response.body,
          responseCode: response.statusCode,
          errorMessage: decodedData['message'],
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          responseData: response.body,
          responseCode: response.statusCode,
        );
      }
    }  catch (e) {
      return NetworkResponse(
        isSuccess: false,
        responseData: null,
        responseCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  void _logRequest(String url,Map<String, dynamic> headers, {Map<String, dynamic>? body}) {
    _logger.i(
      'URL => $url \n'
          'headers: $headers \n'
          'request body: $body',
    );
  }
  void _logResponse(int statusCode, Response response) {
    _logger.i(
      'statusCode: $statusCode \n'
          'response body: ${response.body}',
    );
  }
}
