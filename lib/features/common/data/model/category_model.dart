class CategoryModel {
  final String id;
  final String name;
  final String image;

  CategoryModel({required this.id, required this.name, required this.image});

  factory CategoryModel.formJson(Map<String, dynamic> jsonData) {
    return CategoryModel(
      id: jsonData['_id'] ?? '',
      name: jsonData['name'] ?? '',
      image: jsonData['image'] ?? '',
    );
  }
}
