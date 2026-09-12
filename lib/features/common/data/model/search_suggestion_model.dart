class SearchSuggestionModel {
  final String id;
  final String title;
  final String? image;
  final double price;
  final double? discountPrice;

  SearchSuggestionModel({
    required this.id,
    required this.title,
    this.image,
    required this.price,
    this.discountPrice,
  });

  factory SearchSuggestionModel.fromJson(Map<String, dynamic> json) {
    return SearchSuggestionModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      image: json['image'],
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: json['discountPrice'] != null
          ? (json['discountPrice'] as num).toDouble()
          : null,
    );
  }
}
