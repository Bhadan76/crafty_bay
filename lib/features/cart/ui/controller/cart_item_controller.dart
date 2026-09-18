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

  double _discountAmount = 0;
  String? _appliedCoupon;
  bool _isOutsideDhaka = false;

  double get discountAmount => _discountAmount;
  String? get appliedCoupon => _appliedCoupon;
  bool get isOutsideDhaka => _isOutsideDhaka;

  double get subtotal {
    double total = 0;
    for (var item in _cartList) {
      total += (double.tryParse(item.productListModel?.price ?? '0') ?? 0) *
          item.quantity;
    }
    return total;
  }

  double get shippingCharge {
    // ২০০০ টাকার বেশি হলে শিপিং চার্জ ০ (ফ্রি)
    if (subtotal > 2000 || subtotal == 0) {
      return 0;
    }
    return _isOutsideDhaka ? 120 : 60;
  }

  double get totalPrice {
    // সাবটোটাল + শিপিং - ডিসকাউন্ট
    return (subtotal + shippingCharge) - _discountAmount;
  }

  void toggleShippingLocation(bool isOutside) {
    _isOutsideDhaka = isOutside;
    update();
  }

  void changeQuantity(int index, int newQuantity) {
    _cartList[index] = _cartList[index].copyWith(quantity: newQuantity);
    update();
  }

  Future<bool> applyCoupon(String code) async {
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      url: AppUrls.listCouponsUrl,
    );
    
    if (response.isSuccess) {
      final dataList = response.responseData['data'];
      if (dataList != null && dataList is List) {
        // Find the coupon that matches the entered code and is active
        final couponData = dataList.firstWhere(
          (c) => c['code'] == code && (c['isActive'] ?? false),
          orElse: () => null,
        );

        if (couponData != null) {
          double discountValue = double.tryParse(couponData['discountValue'].toString()) ?? 0;
          double minAmount = double.tryParse(couponData['minOrderAmount'].toString()) ?? 0;
          String type = couponData['discountType'] ?? 'fixed';

          if (subtotal < minAmount) {
            _errorMessage = 'Minimum order for this coupon is \$$minAmount';
            _discountAmount = 0;
            _appliedCoupon = null;
          } else {
            if (type == 'fixed') {
              _discountAmount = discountValue;
            } else {
              _discountAmount = (subtotal * discountValue) / 100;
            }
            _appliedCoupon = code;
            _errorMessage = null;
          }
        } else {
          _errorMessage = 'Invalid or Expired Coupon Code';
          _discountAmount = 0;
          _appliedCoupon = null;
        }
      } else {
        _errorMessage = 'Failed to fetch coupons';
        _discountAmount = 0;
        _appliedCoupon = null;
      }
    } else {
      _errorMessage = response.errorMessage ?? 'Server error';
      _discountAmount = 0;
      _appliedCoupon = null;
    }

    _inProgress = false;
    update();
    return _appliedCoupon != null;
  }

  Future<bool> getCartList () async {
    bool isSuccess = false;
    _inProgress = true;
    _discountAmount = 0;
    _appliedCoupon = null;
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