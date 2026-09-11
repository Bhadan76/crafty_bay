// {
// "_id": "6a85ed15b56eed070d02d2b9",
// "title": "Watches Brand 9 Edition #100",
// "description": "Premium quality Watches designed by Brand 9. Features durable materials, modern design, and exceptional comfort for everyday use. Item #400.",
// "price": 311.7,
// "discountPrice": 236.35,
// "images": [
// "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&q=80",
// "https://picsum.photos/seed/prod_alt_6a85ed15b56eed070d02d0c8_100/600/600"
// ],
// "categoryId": {
// "_id": "6a85ed15b56eed070d02d0c8",
// "name": "Watches",
// "image": "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&q=80"
// },
// "brandId": {
// "_id": "6a85ed14b56eed070d02d0c2",
// "name": "Brand 9",
// "logo": "https://picsum.photos/seed/brand9/400/400"
// },
// "remark": "regular",
// "colors": [
// "Gold",
// "Red"
// ],
// "sizes": [
// "S",
// "M"
// ],
// "stock": 41,
// "__v": 0,
// "createdAt": "2026-08-19T17:51:17.365Z",
// "updatedAt": "2026-08-19T17:51:17.365Z"
// }

class ProductListModel {
  final String? id;
  final String title;
  final String price;
  final BrandIdModel? brandId;
  final String rating;
  final List<String> images;
  final List<String> colors;
  final List<String> sizes;
  final int stock;
  final String description;

  ProductListModel({
    required this.id,
    required this.title,
    required this.price,
    required this.brandId,
    required this.rating,
    required this.images,
    required this.colors,
    required this.sizes,
    required this.stock, required this.description,
  });

  factory ProductListModel.formJson(Map<String, dynamic> jsonData){
    List<dynamic> imagesList = jsonData['images'] ?? [];
    List<dynamic> colorList = jsonData['colors'] ?? [];
    List<dynamic> sizeList = jsonData['sizes'] ?? [];

    BrandIdModel? brand;
    if (jsonData['brandId'] != null && jsonData['brandId'] is Map<String, dynamic>) {
      brand = BrandIdModel.formJson(jsonData['brandId']);
    }

    return ProductListModel(
        id: jsonData['_id'] ?? '',
        title: jsonData['title'] ?? '',
        price: jsonData['price']?.toString() ?? '0',
        brandId: brand,
        rating: (jsonData['rating'] ?? 3.0).toString(),
        images: List<String>.from(imagesList),
        colors: List<String>.from(colorList),
        sizes: List<String>.from(sizeList),
        stock: jsonData['stock'] ?? 0,
        description: jsonData['description'] ?? ''
    );
  }
}

class BrandIdModel {
  final String id;
  final String name;
  final String logo;

  BrandIdModel({required this.id, required this.name, required this.logo});

  factory BrandIdModel.formJson(Map<String, dynamic> jsonData) {
    return BrandIdModel(
      id: jsonData['_id'],
      name: jsonData['name'] ?? '',
      logo: jsonData['logo'] ?? '',
    );
  }
}
