class MarketModel {
  final int id;
  final String name;
  final String description;
  // TODO: int or String?
  final dynamic facebookEventId;
  // TODO: String?
  final String category;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  // TODO: type
  final dynamic location;

  MarketModel.fromJson(dynamic json)
      : id = json["id"],
        name = json["name"],
        description = json["description"],
        facebookEventId = json["facebook_event_id"],
        category = json["category"],
        userId = json["user_id"],
        createdAt = DateTime.tryParse(json["created_at"] ?? ""),
        updatedAt = DateTime.tryParse(json["updated_at"] ?? ""),
        location = json["location"];
}
