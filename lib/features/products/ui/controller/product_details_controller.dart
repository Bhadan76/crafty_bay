import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/common/data/model/product_list_model.dart';
import 'package:get/get.dart';


import 'package:logger/logger.dart';

class ProductDetailsController extends GetxController {
  final Logger _logger = Logger();
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  ProductListModel? _product;

  /// Non-null accessor — call sites must guard with `inProgress`
  /// (product_list_details.dart does this in its GetBuilder).
  ProductListModel get product => _product!;

  /// Safe stock accessor for widgets that don't have the inProgress
  /// guard (e.g. IncrementDecrementCountWidget used inside the cart
  /// screen, where ProductDetailsController is not the source of truth).
  /// Returns 0 while product is null so callers can fall back to "no
  /// upper limit" semantics if they prefer.
  int get currentStock => _product?.stock ?? 0;

  Future<bool> getProductDetails(String productId) async{
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkCaller>()
        .getRequest(url: AppUrls.productDetailsUrl(productId));
    _logger.i('Product Details API Response Status: ${response.responseCode}');
    if (response.isSuccess) {
      _product = ProductListModel.formJson(response.responseData['data']);
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
