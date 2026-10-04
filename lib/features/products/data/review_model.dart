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

  factory ReviewModel.formJson(Map<String, dynamic> jsonData) {
    return ReviewModel(
      productId: jsonData['product_id']?.toString() ?? jsonData['productId']?.toString() ?? '',
      user: jsonData['user'] != null && jsonData['user'] is Map<String, dynamic>
          ? UserDataModel.formJson(jsonData['user'])
          : UserDataModel(
              id: jsonData['_id']?.toString() ?? '',
              firstName: jsonData['firstName']?.toString() ?? jsonData['customerName']?.toString() ?? 'User',
              lastName: jsonData['lastName']?.toString() ?? '',
            ),
      description: jsonData['description']?.toString() ?? jsonData['comment']?.toString() ?? '',
      rating: jsonData['rating']?.toString() ?? '5',
      createdAt: jsonData['createdAt'] != null
          ? (DateTime.tryParse(jsonData['createdAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }
}

class UserDataModel {
  final String id;
  final String firstName;
  final String lastName;

  UserDataModel({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory UserDataModel.formJson(Map<String, dynamic> jsonData) {
    return UserDataModel(
      id: jsonData['_id']?.toString() ?? jsonData['id']?.toString() ?? '',
      firstName: jsonData['firstName']?.toString() ?? jsonData['first_name']?.toString() ?? '',
      lastName: jsonData['lastName']?.toString() ?? jsonData['last_name']?.toString() ?? '',
    );
  }
}

