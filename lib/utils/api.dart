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

  static _Market market = _Market._();
  static _Product product = _Product._();

  static Future<ProductModel> addProductToMarket(
    int productId,
    int marketId,
  ) async {
    final url = Uri.https(
      "targowisko.herokuapp.com",
      "api/v1/markets/${marketId}/add_product",
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
      "targowisko.herokuapp.com",
      "api/v1/markets/${marketId}/remove_product",
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

class _Market {
  const _Market._();

  Future<List<MarketModel>> fetch() async {
    final result = await http.get(
      'https://targowisko.herokuapp.com/api/v1/markets/',
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);

    final List jsonEventList = jsonDecode(result.body);
    jsonEventList.first["place"] = null;
    jsonEventList.first["owner"] = null;
    jsonEventList.first["market_ratings"] = null;

    debugPrint(jsonEventList.first.toString());
    final markets = jsonEventList.map((dynamic market) {
      return MarketModel.fromJson(market);
    }).toList();

    return markets;
  }

  Future<bool> create(List<String> facebookEventIds) async {
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
}

class _Product {
  const _Product._();

  Future<ProductModel> create({
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

  Future<List<ProductModel>> getMyProducts() async {
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

  Future<ProductModel> getOne(int productId) async {
    final result = await http.get(
      'https://targowisko.herokuapp.com/api/v1/products/${productId}',
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return ProductModel.fromJson(json.decode(result.body));
  }

  Future<List<ProductModel>> getAll({int perPage, int pageNumber}) async =>
      fetch(perPage: perPage, pageNumber: pageNumber);

  Future<List<ProductModel>> fetch({
    int userId,
    String searchValue,
    int perPage,
    int pageNumber,
    int marketId,
  }) async {

    final params = <String, String>{};
    if (userId != null) params["user_id"] = userId.toString();
    if (searchValue != null) params["search_value"] = searchValue.toString();
    if (perPage != null) params["items"] = perPage.toString();
    if (pageNumber != null) params["page"] = pageNumber.toString();
    if (marketId != null) params["market_id"] = marketId.toString();

    print("Params");
    print(params);

    final url = Uri.https(
      "targowisko.herokuapp.com",
      "api/v1/products",
      params,
    );

    final result = await http.get(
      url,
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return (json.decode(result.body) as List)
        .map((dynamic product) => ProductModel.fromJson(product))
        .toList();
  }
}
