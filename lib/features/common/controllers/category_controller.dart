import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/common/data/model/category_model.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  bool _isInitialLoading = true;
  String? _errorMessage;
  List<CategoryModel> _categoryList = [];

  bool get isInitialLoading => _isInitialLoading;
  String? get errorMessage => _errorMessage;
  List<CategoryModel> get categoryList => _categoryList;

  Future<bool> getCategoryList() async {
    bool isSuccess = false;
    _isInitialLoading = true;
    update();

    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      url: AppUrls.categoryUrl,
    );

    if (response.isSuccess) {
      List<CategoryModel> list = [];
      final data = response.responseData;
      if (data != null && data['data'] != null) {
        for (Map<String, dynamic> item in data['data']) {
          list.add(CategoryModel.formJson(item));
        }
      }
      _categoryList = list;
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _isInitialLoading = false;
    update();
    return isSuccess;
  }
}
