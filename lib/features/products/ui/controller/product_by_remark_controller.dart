import 'package:crafty_bay/app/app_urls.dart';
import 'package:crafty_bay/core/network_caller/network_caller.dart';
import 'package:crafty_bay/features/products/data/models/product_list_model.dart';
import 'package:get/get.dart';

class ProductByRemarkController extends GetxController {
  final Map<String, bool> _inProgress = {
    'popular': false,
    'special': false,
    'new': false,
  };

  List<ProductListModel> _popularProducts = [];
  List<ProductListModel> _specialProducts = [];
  List<ProductListModel> _newProducts = [];

  bool inProgress(String remark) => _inProgress[remark] ?? false;
  List<ProductListModel> get popularProducts => _popularProducts;
  List<ProductListModel> get specialProducts => _specialProducts;
  List<ProductListModel> get newProducts => _newProducts;

  Future<bool> getProductByRemark(String remark) async {
    bool isSuccess = false;
    _inProgress[remark] = true;
    update();

    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      url: AppUrls.productByRemarkUrl(remark),
    );

    if (response.isSuccess) {
      List<ProductListModel> list = [];
      final data = response.responseData;
      if (data != null && data['data'] != null) {
        for (Map<String, dynamic> item in data['data']) {
          list.add(ProductListModel.formJson(item));
        }
      }

      if (remark == 'popular') {
        _popularProducts = list;
      } else if (remark == 'special') {
        _specialProducts = list;
      } else if (remark == 'new') {
        _newProducts = list;
      }
      isSuccess = true;
    }

    _inProgress[remark] = false;
    update();
    return isSuccess;
  }
}
