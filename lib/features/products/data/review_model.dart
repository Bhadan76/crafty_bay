// "_id": "6ab385c56fd850ccdbc6f790",
// "product_id": "6a7cba9113d2766a6357a642",
// "user": {
// "_id": "6a7d8993507d7f30da0bb69a",
// "firstName": "Rahim",
// "lastName": "Uddin"
// },
// "description": "Excellent product! Highly recommended.",
// "rating": 5,
// "createdAt": "2026-09-23T07:54:45.213Z",
// "updatedAt": "2026-09-23T07:54:45.213Z",
// "__v": 0
class ReviewModel {
  final String productId;
  final String description;
  final String rating;
  final DateTime createdAt;
  final UserDataModel user;

  ReviewModel({
    required this.productId,
    required this.user,
    required this.description,
    required this.rating,
    required this.createdAt,
  });
  factory ReviewModel.formJson(Map<String,dynamic> jsonData){
    return ReviewModel(
      productId: jsonData['product_id'],
      user: UserDataModel.formJson(jsonData['user']),
      description: jsonData['description'],
      rating: jsonData['rating'],
      createdAt: DateTime.parse(jsonData['createdAt']),
    );
  }
}

class UserDataModel{
  final String id;
  final String firstName;
  final String lastName;

  UserDataModel({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory UserDataModel.formJson(Map<String, dynamic> jsonData) {
    return UserDataModel(id: jsonData['_id'], firstName: jsonData['firstName'], lastName: jsonData['lastName']);
  }
}
