import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ProductAddToCartController extends GetxController {
  final Logger _logger = Logger();
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> addToCart(String? productId, String color, String size, int quantity) async {
    bool isSuccess = false;
    _inProgress = true;
    _errorMessage = null;
    update();

    final Map<String, dynamic> requestBody = {
      "product_id": productId,
      "color": color,
      "size": size,
      "quantity": quantity,
    };

    final NetworkResponse response = await Get.find<NetworkCaller>().postRequest(
      url: AppUrls.addToCartUrl,
      body: requestBody,
    );

    _logger.i('Add to Cart API Response Status: ${response.responseCode}');
    
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    
    _inProgress = false;
    update();
    return isSuccess;
  }
}
