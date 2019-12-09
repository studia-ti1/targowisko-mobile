import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/models/owner_model.dart';
import 'package:targowisko/models/product_model.dart';

class Api {
  /// private constructor
  Api._();

  static String accesToken;

  static _Market market = _Market._();
  static _Product product = _Product._();

  static Future<void> setFbAvatar() async {
    final url = Uri.https(
      "targowisko.herokuapp.com",
      "api/v1/users/api_update_avatar.json",
    );
    final result = await http.post(
      url,
      headers: {
        'access-token': Api.accesToken,
      },
    );
    print(result.body);
    if (result.statusCode >= 300) throw ApiException(message: result.body);
  }

  static Future<OwnerModel> getAboutMe() async {
    final url = Uri.https(
      "targowisko.herokuapp.com",
      "api/v1/about_me",
    );
    final result = await http.get(
      url,
      headers: {
        'access-token': Api.accesToken,
      },
    );
    print(result.body);
    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return OwnerModel.fromJson(json.decode(result.body));
  }

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

  static Future<List<MarketModel>> getAllEventsFromFb() async {
    final result = await http.post(
      'https://targowisko.herokuapp.com/api/v1/markets/fetch_from_api.json',
      headers: {
        'access-token': Api.accesToken,
      },
    );

    // print(result.body);

    if (result.statusCode >= 300) throw ApiException(message: result.body);

    final List jsonEventList = jsonDecode(result.body);

    final markets = jsonEventList.map((dynamic market) {
      return MarketModel.fromJson(market);
    }).toList();

    return markets;
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
      'https://targowisko.herokuapp.com/api/v1/markets.json',
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
      body: <String, dynamic>{
        "facebook_event_ids": json.encode(facebookEventIds)
      },
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
    String description, // ?
    @required ProductCategory category,
  }) async {
    assert(category != null);

    final url = Uri.https(
      "targowisko.herokuapp.com",
      "api/v1/products.json",
    );
    final request = http.MultipartRequest("POST", url);

    request.fields["category"] = category.value;

    if (name != null) request.fields["name"] = name.toString();
    if (description != null)
      request.fields["description"] = description.toString();
    if (price != null) request.fields["price"] = price.toString();

    if (picture != null) {
      final file = await http.MultipartFile.fromPath("picture", picture.path);
      request.files.add(file);
    }

    request.headers["access-token"] = Api.accesToken;

    http.StreamedResponse response = await request.send();

    final body = await response.stream.bytesToString();

    if (response.statusCode >= 300) throw ApiException(message: body);
    return ProductModel.fromJson(json.decode(body));
  }

  Future<List<ProductModel>> getMyProducts() async {
    final result = await http.get(
      'https://targowisko.herokuapp.com/api/v1/products.json',
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

    final url = Uri.https(
      "targowisko.herokuapp.com",
      "api/v1/products.json",
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
