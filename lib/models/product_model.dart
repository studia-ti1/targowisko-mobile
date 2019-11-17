import 'market_model.dart';
import 'owner_model.dart';

class ProductModel {
  final int id;
  final String name;
  final String description;
  final String picture;
  final double price;
  final int userId;
  final OwnerModel owner;
  final List<MarketModel> markets;
  final List<dynamic> productRatings;

  ProductModel.fromJson(dynamic json)
      : id = json["id"],
        name = json["name"],
        description = json["description"],
        price = json["price"],
        owner =
            json["owner"] != null ? OwnerModel.fromJson(json["owner"]) : null,
        userId = json["user"] != null ? json["user"]["id"] : null,
        picture = json["picture"] != null ? json["picture"] : null,
        markets = json["markets"] != null
            ? (json["markets"] as List)
                .map((dynamic jsonMarket) => MarketModel.fromJson(jsonMarket))
                .toList()
            : null,
        productRatings = json["product_ratings"];
}
