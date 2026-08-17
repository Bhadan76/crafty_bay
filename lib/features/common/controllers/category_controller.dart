import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/common/data/model/category_model.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  bool _inProgress = false;
  bool _isLoadingMore = false;
  final int _countData =10;
  int _currentPage = 1;
  int? _totalPages;
  
  String? _errorMessage;
  List<CategoryModel> _categoryList = [];

  bool get inProgress => _inProgress;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<CategoryModel> get categoryList => _categoryList;

  Future<bool> getCategoryList({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _categoryList.clear();
      _totalPages = null;
    }

    // Stop if we already loaded all pages
    if (_totalPages != null && _currentPage > _totalPages!) {
      return false;
    }

    // Avoid multiple concurrent requests
    if (_inProgress || _isLoadingMore) return false;

    if (_currentPage == 1) {
      _inProgress = true;
    } else {
      _isLoadingMore = true;
    }
    update();

    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      url: AppUrls.categoryUrl,
      queryParameters: {
        'page': _currentPage,
        'count': _countData, // Adjust count as per your API requirement
      },
    );

    bool isSuccess = false;
    if (response.isSuccess) {
      final data = response.responseData;
      if (data != null && data['data'] != null) {
        for (Map<String, dynamic> item in data['data']) {
          _categoryList.add(CategoryModel.formJson(item));
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
}
