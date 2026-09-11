import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/cart/data/model/cart_item_model.dart';
import 'package:get/get.dart';

class CartItemController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<CartItemModel> _cartList = [];
  List<CartItemModel> get cartList => _cartList;

  double get totalPrice {
    double total = 0;
    for (var item in _cartList) {
      total += (double.tryParse(item.productListModel?.price ?? '0') ?? 0) *
          item.quantity;
    }
    return total;
  }

  void changeQuantity(int index, int newQuantity) {
    _cartList[index] = _cartList[index].copyWith(quantity: newQuantity);
    update();
  }

  Future<bool> getCartList () async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(url: AppUrls.cartListUrl);
    if(response.isSuccess){
      List<CartItemModel> list = [];
      final data = response.responseData['data'];
      if (data != null && data is List) {
        for (Map<String, dynamic> item in data) {
          list.add(CartItemModel.formJson(item));
        }
      }
      _cartList = list;
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}