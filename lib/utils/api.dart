import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/models/product_model.dart';

class Api {
  /// private constructor
  Api._();

  static String accesToken;

  static Future<List<MarketModel>> fetchMarkets() async {
    final result = await http.get(
      'https://targowisko.herokuapp.com/api/v1/markets/',
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);

    final List jsonEventList = jsonDecode(result.body);
    final markets = jsonEventList.map((dynamic market) {
      return MarketModel.fromJson(market);
    }).toList();

    return markets;
  }

  static Future<MarketModel> updateMarket(
    int marketId, {
    String name,
    String description,
    File avatar,
    int category,
    Map<String, dynamic> location,
  }) async {
    final result = await http.patch(
      'https://targowisko.herokuapp.com/api/v1/markets/${marketId}',
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

  static Future<bool> deleteMarket(int marketId) async {
    final result = await http.delete(
      'https://targowisko.herokuapp.com/api/v1/markets/${marketId}',
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return json.decode(result.body)["success"] == true;
  }

  static Future<bool> createMarkets(List<String> facebookEventIds) async {
    final result = await http.post(
      'https://targowisko.herokuapp.com/api/v1/create_markets',
      body: <String, dynamic>{"facebook_event_ids": facebookEventIds},
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return json.decode(result.body)["success"] == true;
  }

  static Future<ProductModel> createProduct({
    String name,
    File picture,
    int price,
    int category,
    String description, // ?
  }) async {
    final result = await http.post(
      'https://targowisko.herokuapp.com/api/v1/products',
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

  static Future<List<ProductModel>> getMyProducts() async {
    final result = await http.get(
      'https://targowisko.herokuapp.com/api/v1/products',
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return (json.decode(result.body) as List)
        .map((dynamic product) => ProductModel.fromJson(product))
        .toList();
  }

  static Future<ProductModel> getProduct(int productId) async {
    final result = await http.get(
      'https://targowisko.herokuapp.com/api/v1/products/${productId}',
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return ProductModel.fromJson(json.decode(result.body));
  }

  static Future<ProductModel> updateProduct(
    int productId, {
    String name,
    File picture,
    int price,
    int category,
    String description, // ?
  }) async {
    final result = await http.patch(
      'https://targowisko.herokuapp.com/api/v1/products/${productId}',
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

  static Future<ProductModel> addProductToMarket(
    int productId,
    int marketId,
  ) async {
    final url = Uri.https(
      "targowisko.herokuapp.com/api/v1",
      "markets/${marketId}/add_product",
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

  static Future<ProductModel> removeProductFromMarket(
    int productId,
    int marketId,
  ) async {
    final url = Uri.https(
      "targowisko.herokuapp.com/api/v1",
      "markets/${marketId}/remove_product",
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

  static Future<http.Response> getAllEventsFromFb() async {
    final result = await http.post(
      'https://targowisko.herokuapp.com/api/v1/markets/fetch_from_api.json',
      headers: {
        'access-token': Api.accesToken,
      },
    );
    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return result;
  }
}

class ApiException implements Exception {
  final String message;

  ApiException({@required this.message});
}
