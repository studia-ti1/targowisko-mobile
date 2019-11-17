import 'dart:convert';
import 'dart:io';

import 'package:targowisko/utils/api.dart';

import 'market_model.dart';
import 'owner_model.dart';

import 'package:http/http.dart' as http;

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

  Future<ProductModel> update({
    String name,
    File picture,
    int price,
    int category,
    String description, // ?
  }) async {
    assert(id != null);

    final result = await http.patch(
      'https://targowisko.herokuapp.com/api/v1/products/${this.id}',
      body: <String, dynamic>{
        "name": name,
        "description": description,
        "picture": picture,
        "price": price,
        "category": category,
      },
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return ProductModel.fromJson(json.decode(result.body));
  }

  Future<ProductModel> addToMarket(
    int marketId,
  ) async {
    final url = Uri.https(
      "targowisko.herokuapp.com/api/v1",
      "markets/${marketId}/add_product",
      <String, String>{
        "product_id": this.id.toString(),
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

  Future<ProductModel> removeFromMarket(
    int marketId,
  ) async {
    final url = Uri.https(
      "targowisko.herokuapp.com/api/v1",
      "markets/${marketId}/remove_product",
      <String, String>{
        "product_id": this.id.toString(),
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