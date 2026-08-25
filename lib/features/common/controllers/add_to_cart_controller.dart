import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class AddToCartController extends GetxController {
  final Logger _logger = Logger();
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> getAddToCartProduct(String productId, String color, String size) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    
    final NetworkResponse response = await Get.find<NetworkCaller>().postRequest(
      url: AppUrls.addToCartUrl,
      body: {
        "productId": productId,
        "color": color,
        "size": size,
      },
    );

    _logger.i('Add to Cart Response Status: ${response.responseCode}');
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
