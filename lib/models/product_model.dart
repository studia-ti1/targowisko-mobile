import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:targowisko/models/rating_model.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';

import 'market_model.dart';
import 'owner_model.dart';

import 'package:http/http.dart' as http;

class ProductCategory {
  const ProductCategory._(this._value, this._name, this._assetName);

  final String _value;
  final String _name;
  final String _assetName;

  String get value => _value;
  String get name => _name;
  String get assetName => _assetName;

  static const ProductCategory electronics = ProductCategory._(
    "electronics",
    "Elektronika",
    CategoriesAssets.electronics,
  );
  static const ProductCategory clothing = ProductCategory._(
    "clothing",
    "Odziez",
    CategoriesAssets.clothing,
  );
  static const ProductCategory cosmetics = ProductCategory._(
    "cosmetics",
    "Kosmetyki",
    CategoriesAssets.cosmetics,
  );
  static const ProductCategory other = ProductCategory._(
    "other",
    "Inne",
    CategoriesAssets.other,
  );
  static const ProductCategory automotive = ProductCategory._(
    "automotive",
    "Motoryzacja",
    CategoriesAssets.automotive,
  );
  static const ProductCategory animals = ProductCategory._(
    "animals",
    "Zwierzęta",
    CategoriesAssets.animals,
  );
  static const ProductCategory antiques = ProductCategory._(
    "antiques",
    "Antyki",
    CategoriesAssets.antiques,
  );
  static const ProductCategory realEstate = ProductCategory._(
    "real_estate",
    "Nieruchomości",
    CategoriesAssets.realEstate,
  );
  static const ProductCategory food = ProductCategory._(
    "food",
    "Żywność",
    CategoriesAssets.food,
  );

  static const allCategories = [
    // vegetables,
    // fruits,
    food,
    clothing,
    cosmetics,
    automotive,
    animals,
    antiques,
    realEstate,
    electronics,
    other,
  ];
}

class ProductModel {
  final int id;
  final String name;
  final String description;
  final String picture;
  final double price;
  final int userId;
  final OwnerModel owner;
  final List<MarketModel> markets;
  final List<RatingModel> productRatings;
  final double averageRating;
  final String category;

  ProductModel.fromJson(dynamic json)
      : id = json["id"],
        name = json["name"],
        category = json["category"],
        description = json["description"],
        // TODO: Backend for some reason returns int instead of double
        price = double.tryParse(json["price"]?.toString() ?? ""),
        owner =
            json["owner"] != null ? OwnerModel.fromJson(json["owner"]) : null,
        userId = json["user"] != null ? json["user"]["id"] : null,
        picture = json["picture"] != null ? json["picture"]["url"] : null,
        markets = json["markets"] != null
            ? (json["markets"] as List)
                .map((dynamic jsonMarket) => MarketModel.fromJson(jsonMarket))
                .toList()
            : null,
        productRatings = json["product_ratings"] != null
            ? (json["markets"] as List)
                .map((dynamic jsonRating) => RatingModel.fromJson(jsonRating))
                .toList()
            : null,
        averageRating = json["average_rating"];

  ProductCategory getCateogry() => ProductCategory.allCategories
      .firstWhere((cat) => cat.value == category, orElse: () => null);

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
