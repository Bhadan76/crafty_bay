import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/common/data/model/product_list_model.dart';
import 'package:get/get.dart';

class WishListController extends GetxController {
  bool _inProgress = false;
  bool _isLoadingMore = false;
  final int _countData = 10;
  int _currentPage = 1;
  int? _totalPages;

  bool get inProgress => _inProgress;
  bool get isLoadingMore => _isLoadingMore;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final List<ProductListModel> _wishList = [];
  List<ProductListModel> get wishList => _wishList;

  Future<bool> getWishList() async {
    if (_totalPages != null && _currentPage > _totalPages!) {
      return false;
    }

    if (_inProgress || _isLoadingMore) return false;

    if (_currentPage == 1) {
      _inProgress = true;
    } else {
      _isLoadingMore = true;
    }
    update();

    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      url: AppUrls.wishListUrl,
      queryParameters: {
        'page': _currentPage,
        'count': _countData,
      },
    );

    bool isSuccess = false;
    if (response.isSuccess) {
      if (_currentPage == 1) {
        _wishList.clear();
      }
      
      final data = response.responseData;
      if (data != null && data['data'] != null) {
        for (Map<String, dynamic> item in data['data']) {
          if (item['product_id'] != null && item['product_id'] is Map<String, dynamic>) {
            _wishList.add(ProductListModel.formJson(item['product_id']));
          } else {
            // Fallback: If product_id is not present, try to parse the item itself
            _wishList.add(ProductListModel.formJson(item));
          }
        }
        
        if (data['pagination'] != null) {
          _totalPages = data['pagination']['totalPages'];
        }
        _currentPage++;
      }
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    _isLoadingMore = false;
    update();
    return isSuccess;
  }

  Future<bool> refreshLoading() {
    _currentPage = 1;
    _wishList.clear();
    _totalPages = null;
    return getWishList();
  }
}
