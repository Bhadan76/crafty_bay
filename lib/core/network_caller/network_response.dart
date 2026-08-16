part of 'network_caller.dart';

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