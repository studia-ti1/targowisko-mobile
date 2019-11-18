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
  final String name;
  final String description;
  final String facebookEventId;
  final LocationModel place;
  final OwnerModel owner;
  final String imageUrl;
  final int userId;
  final List<ProductModel> products;
  final List<RatingModel> marketRaitings;
  final double averageRating;

  MarketModel.fromJson(dynamic json)
      : id = json["id"],
        name = json["name"],
        averageRating = json["average_rating"],
        description = json["description"],
        facebookEventId = json["facebook_event_id"],
        place = json["place"] != null
            ? LocationModel.fromJson(json["place"])
            : null,
        owner =
            json["owner"] != null ? OwnerModel.fromJson(json["owner"]) : null,
        userId = json["user"] != null ? json["user"]["id"] : null,
        imageUrl = json["image"] != null ? json["image"]["url"] : null,
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


