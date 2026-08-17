class SliderModel {
  final String id;
  final String title;
  final String price;
  final String? discountPrice;
  final String? image;
  final String description;

  SliderModel({
    required this.id,
    this.image,
    required this.description,
    required this.title,
    required this.price,
    this.discountPrice,
  });

  factory SliderModel.formJson(Map<String, dynamic> jsonData) {
    String? imageUrl;
    if (jsonData['images'] != null && jsonData['images'] is List && (jsonData['images'] as List).isNotEmpty) {
      imageUrl = jsonData['images'][0];
    }

    return SliderModel(
      id: jsonData['_id'] ?? '',
      image: imageUrl,
      description: jsonData['description'] ?? '',
      title: jsonData['title'] ?? '',
      price: jsonData['price']?.toString() ?? '0',
      discountPrice: jsonData['discountPrice']?.toString(),
    );
  }
}
