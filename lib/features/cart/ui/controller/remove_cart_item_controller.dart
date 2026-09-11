import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:get/get.dart';

import '../../data/model/cart_item_model.dart';

class RemoveCartItemController extends GetxController {
  final List<String> _deletingItemIds = [];
  String? _errorMessage;
  List<CartItemModel> _cartList = [];

  bool isDeleting(String cartId) => _deletingItemIds.contains(cartId);
  String? get errorMessage => _errorMessage;
  List<CartItemModel> get cartList => _cartList;

  Future<bool> getRemoveCartItem(String cartId) async {
    bool isSuccess = false;
    _deletingItemIds.add(cartId);
    update();

    final NetworkResponse response = await Get.find<NetworkCaller>()
        .deleteRequest(url: AppUrls.removeCartItemUrl(cartId));

    if (response.isSuccess) {
      _deletingItemIds.remove(cartId);
      isSuccess = true;
      _errorMessage = null;
    } else {
      _deletingItemIds.remove(cartId);
      _errorMessage = response.errorMessage;
    }
    update();
    return isSuccess;
  }
}
