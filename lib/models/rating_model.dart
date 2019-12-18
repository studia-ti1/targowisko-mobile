import 'package:meta/meta.dart';

class RatingModel {
  final int id;
  final int marketId;
  final int userId;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  RatingModel({
    @required this.marketId,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.id,
    @required this.comment,
    @required this.userId,
    @required this.rating,
  });

  RatingModel.fromJson(dynamic json)
      : id = json["id"],
        marketId = json["market_id"],
        userId = json["user_id"],
        rating = json["rating"],
        comment = json["comment"],
        createdAt = json["created_at"] != null
            ? DateTime.tryParse(json["created_at"] ?? "")
            : null,
        updatedAt = json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"] ?? "")
            : null;
}
