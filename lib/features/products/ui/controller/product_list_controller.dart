import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:get/get.dart';

import '../../data/models/product_list_model.dart';

class ProductListController extends GetxController {
  bool _inProgress = false;
  bool _isLoadingMore = false;
  final int _countData =10;
  int _currentPage = 1;
  int? _totalPages;

  String? _errorMessage;
  final List<ProductListModel> _productList = [];

  bool get inProgress => _inProgress;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<ProductListModel> get productList => _productList;

  Future<bool> getProductListCategory(String categoryId) async {

    // Stop if we already loaded all pages
    if (_totalPages != null && _currentPage > _totalPages!) {
      return false;
    }

    // Avoid multiple concurrent requests
    if (_inProgress || _isLoadingMore) return false;

    if (_currentPage == 1) {
      _inProgress = true;
      _productList.clear(); // নতুন ক্যাটাগরি লোড করার আগে আগের ডাটা ক্লিয়ার করা হচ্ছে
    } else {
      _isLoadingMore = true;
    }
    update();

    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      url: AppUrls.productListUrl(categoryId),
      queryParameters: {
        'page': _currentPage,
        'count': _countData,
      },
    );

    bool isSuccess = false;
    if (response.isSuccess) {
      final data = response.responseData;
      if (data != null && data['data'] != null) {
        for (Map<String, dynamic> item in data['data']) {
          _productList.add(ProductListModel.formJson(item));
        }
        // Parsing pagination data
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
  Future<bool> refreshLoading(String categoryId){
    _currentPage = 1;
    _productList.clear();
    _totalPages = null;
    return getProductListCategory(categoryId);
  }
}
