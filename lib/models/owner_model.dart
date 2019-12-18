import 'package:targowisko/models/product_model.dart';

class OwnerModel {
  final int id;
  final String lastName;
  final String firstName;
  final String email;
  final String password;
  final String phoneNumber;
  final int productsCount;
  double averageRating;
  final int role;
  String avatar;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProductModel> products;

  OwnerModel.fromJson(dynamic json)
      : id = json["id"],
        lastName = json["last_name"],
        firstName = json["first_name"],
        email = json["email"],
        avatar = json["avatar"] != null ? json["avatar"]["url"] : null,
        password = json["password"],
        phoneNumber = json["phone_number"],
        productsCount = json["products_count"],
        averageRating = json["average_rating"],
        products = (json["products"] as List)
            ?.map((dynamic productJson) => ProductModel.fromJson(productJson))
            ?.toList(),
        role = json["role"],
        createdAt = DateTime.tryParse(json["created_at"] ?? ""),
        updatedAt = DateTime.tryParse(json["updated_at"] ?? "");

  String get fullName => "${firstName} ${lastName}";
}
