import 'location_model.dart';
import 'owner_model.dart';

class MarketModel {
  final int id;
  final String name;
  final String description;
  final String facebookEventId;
  final LocationModel location;
  final OwnerModel owner;
  final String imageUrl;
  final int userId;
  // TODO: model
  final List<dynamic> products;
  // TODO: type
  final List<dynamic> marketRaitings;

  MarketModel.fromJson(dynamic json)
      : id = json["id"],
        name = json["name"],
        description = json["description"],
        facebookEventId = json["facebook_event_id"],
        location = json["location"] != null
            ? LocationModel.fromJson(json["location"])
            : null,
        owner =
            json["owner"] != null ? OwnerModel.fromJson(json["owner"]) : null,
        userId = json["user"] != null ? json["user"]["id"] : null,
        imageUrl = json["image"] != null ? json["image"]["url"] : null,
        products = const <dynamic>[],
        marketRaitings = const <dynamic>[];
}
