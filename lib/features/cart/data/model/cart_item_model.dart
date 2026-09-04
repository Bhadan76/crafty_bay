
import 'package:crafty_bay/features/common/data/model/product_list_model.dart';

class CartItemModel {
  final ProductListModel? productListModel;
  final int quantity;
  final String color;
  final String size;

  CartItemModel({
    required this.productListModel,
    required this.quantity,
    required this.color,
    required this.size,
  });

  factory CartItemModel.formJson(Map<String, dynamic> jsonData) {
    return CartItemModel(
      productListModel: jsonData['product_id'] != null
          ? ProductListModel.formJson(jsonData['product_id'])
          : null,
      quantity: jsonData['quantity'] ?? 1,
      color: jsonData['color'] ?? '',
      size: jsonData['size'] ?? '',
    );
  }
}
