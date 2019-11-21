class OwnerModel {
  final int id;
  final String lastName;
  final String firstName;
  final String email;
  final String password;
  final String phoneNumber;
  final int role;
  final DateTime createdAt;
  final DateTime updatedAt;

  OwnerModel.fromJson(dynamic json)
      : id = json["id"],
        lastName = json["last_name"],
        firstName = json["first_name"],
        email = json["email"],
        password = json["password"],
        phoneNumber = json["phone_number"],
        role = json["role"],
        createdAt = DateTime.tryParse(json["created_at"] ?? ""),
        updatedAt = DateTime.tryParse(json["updated_at"] ?? "");

  String get fullName => "${firstName} ${lastName}";
}
