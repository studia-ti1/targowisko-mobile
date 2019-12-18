import 'dart:convert';
import 'dart:io';

import 'package:targowisko/models/product_model.dart';
import 'package:targowisko/models/rating_model.dart';
import 'package:targowisko/utils/api.dart';

import 'location_model.dart';
import 'owner_model.dart';

import 'package:http/http.dart' as http;

class MarketModel {
  final int id;
  String name;
  bool going;
  String description;
  String facebookEventId;
  LocationModel place;
  OwnerModel owner;
  String imageUrl;
  int userId;
  List<ProductModel> products;
  List<RatingModel> marketRaitings;
  double averageRating;
  int participants;
  List<OwnerModel> sellers;

  void setWith(MarketModel marketModel) {
    if (marketModel.owner != null) owner = marketModel.owner;
    if (marketModel.name != null) name = marketModel.name;
    if (marketModel.going != null) going = marketModel.going;
    if (marketModel.description != null) description = marketModel.description;
    if (marketModel.facebookEventId != null)
      facebookEventId = marketModel.facebookEventId;
    if (marketModel.place != null) place = marketModel.place;
    if (marketModel.userId != null) userId = marketModel.userId;
    if (marketModel.sellers != null) sellers = marketModel.sellers;
    if (marketModel.participants != null)
      participants = marketModel.participants;
    if (marketModel.averageRating != null)
      averageRating = marketModel.averageRating;
    if (marketModel.marketRaitings != null)
      marketRaitings = marketModel.marketRaitings;
    if (marketModel.products != null) products = marketModel.products;
    if (marketModel.imageUrl != null) imageUrl = marketModel.imageUrl;
  }

  MarketModel.fromJson(dynamic json)
      : id = int.tryParse(json["id"].toString()),
        name = json["name"],
        going = json["going"],
        averageRating = json["average_rating"],
        description = json["description"],
        participants = json["participants"],
        facebookEventId = json["facebook_event_id"],
        sellers = json["sellers"] == null
            ? null
            : (json["sellers"] as List)
                .map((dynamic product) => OwnerModel.fromJson(product))
                .toList(),
        place = json["place"] != null
            ? LocationModel.fromJson(json["place"])
            : null,
        owner =
            json["owner"] != null ? OwnerModel.fromJson(json["owner"]) : null,
        userId = json["user"] != null ? json["user"]["id"] : null,
        imageUrl = json["photo"] ??
            (json["image"] != null ? json["image"]["url"] : null),
        products = json["products"] == null
            ? null
            : (json["products"] as List)
                .map((dynamic product) => ProductModel.fromJson(product))
                .toList(),
        marketRaitings = json["market_ratings"] == null
            ? null
            : (json["market_ratings"] as List)
                .map((dynamic rating) => RatingModel.fromJson(rating))
                .toList();

  Future<MarketModel> update({
    String name,
    String description,
    File avatar,
    int category,
    Map<String, dynamic> location,
  }) async {
    assert(id != null);

    final result = await http.patch(
      'https://targowisko.herokuapp.com/api/v1/markets/${this.id}',
      body: <String, dynamic>{
        "name": name,
        "description": description,
        "avatar": avatar,
        "category": category,
        "location": location,
      },
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return MarketModel.fromJson(json.decode(result.body));
  }

  Future<bool> delete() async {
    assert(id != null);

    final result = await http.delete(
      'https://targowisko.herokuapp.com/api/v1/markets/${this.id}',
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return json.decode(result.body)["success"] == true;
  }

  Future<ProductModel> addProduct(
    int productId,
  ) async {
    final url = Uri.https(
      "targowisko.herokuapp.com/api/v1",
      "markets/${this.id}/add_product",
      <String, String>{
        "product_id": productId.toString(),
      },
    );
    final result = await http.post(
      url,
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return ProductModel.fromJson(json.decode(result.body));
  }

  Future<ProductModel> removeProduct(
    int productId,
  ) async {
    final url = Uri.https(
      "targowisko.herokuapp.com/api/v1",
      "markets/${this.id}/remove_product",
      <String, String>{
        "product_id": productId.toString(),
      },
    );
    final result = await http.delete(
      url,
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return ProductModel.fromJson(json.decode(result.body));
  }
}
