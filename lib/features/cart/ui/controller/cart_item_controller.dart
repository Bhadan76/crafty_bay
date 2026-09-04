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
  Future<bool> getCartList () async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(url: AppUrls.CartListUrl);
    if(response.isSuccess){
      List<CartItemModel> list = [];
      for(Map<String,dynamic> data in response.responseData['data']){
        list.add(CartItemModel.formJson(data));
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