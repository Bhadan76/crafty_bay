// {
// "product_id": "6a7cba9113d2766a6357a64b",
// "color": "Red",
// "size": "XL",
// "quantity": 1
// }

class ProductAddToCartModel {
  final String productId;
  final String color;
  final String size;
  final String quantity;

  ProductAddToCartModel({
    required this.productId,
    required this.color,
    required this.size,
    required this.quantity,
  });

  factory ProductAddToCartModel.formJson(Map<String, dynamic> jsonData) {
    return ProductAddToCartModel(
      productId: jsonData['product_id'],
      color: jsonData['color'],
      size: jsonData['size'],
      quantity: jsonData['quantity'],
    );
  }
}
