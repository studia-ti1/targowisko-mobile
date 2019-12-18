import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/models/owner_model.dart';
import 'package:targowisko/models/product_model.dart';

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

class Api {
  /// private constructor
  Api._();

  static OwnerModel currentUser;

  static Future<List<OwnerModel>> fetchUsers() async {
    final url = Uri.https(
      "targowisko.herokuapp.com",
      "api/v1/users.json",
    );

    final result = await http.get(
      url,
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return (json.decode(result.body) as List)
        .map((dynamic seller) => OwnerModel.fromJson(seller))
        .toList();
  }

  static Future<List<OwnerModel>> fetchBestUsers() async {
    final url = Uri.https(
      "targowisko.herokuapp.com",
      "api/v1/top_users.json",
    );

    final result = await http.get(
      url,
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return (json.decode(result.body) as List)
        .map((dynamic sellet) => OwnerModel.fromJson(sellet))
        .toList();
  }

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
    if (result.statusCode >= 300) throw ApiException(message: result.body);
  }

  static Future<void> attendMarket(int marketId) async {
    final url = Uri.https(
      "targowisko.herokuapp.com",
      "api/v1/markets/${marketId}/attend.json",
    );
    final result = await http.post(
      url,
      headers: {
        'access-token': Api.accesToken,
      },
    );
    if (result.statusCode >= 300) throw ApiException(message: result.body);
  }

  static Future<OwnerModel> getAboutMe() async {
    final url = Uri.https(
      "targowisko.herokuapp.com",
      "api/v1/about_me.json",
    );
    final result = await http.get(
      url,
      headers: {
        'access-token': Api.accesToken,
      },
    );
    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return Api.currentUser = OwnerModel.fromJson(json.decode(result.body));
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

Future<bool> rateUser({
  @required int userId,
  @required int rating,
  @required String comment,
}) async {
  final result = await http.post(
      'https://targowisko.herokuapp.com/api/v1/users/${userId}/rate.json',
      headers: {
        'access-token': Api.accesToken,
      },
      body: <String, String>{
        "rating": rating.toString(),
        "comment": comment,
      });

  if (result.statusCode >= 300) throw ApiException(message: result.body);
  return true;
}

class _Market {
  const _Market._();

  Future<bool> rate({
    @required int marketId,
    @required int rating,
    @required String comment,
  }) async {
    final result = await http.post(
        'https://targowisko.herokuapp.com/api/v1/markets/${marketId}/rate.json',
        headers: {
          'access-token': Api.accesToken,
        },
        body: <String, String>{
          "rating": rating.toString(),
          "comment": comment,
        });

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return true;
  }

  Future<List<MarketModel>> fetch({
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
      "api/v1/markets.json",
      params,
    );

    final result = await http.get(
      url,
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

  Future<bool> create(List<String> facebookEventIds) async {
    final result = await http.post(
      'https://targowisko.herokuapp.com/api/v1/create_markets',
      body: json
          .encode(<String, dynamic>{"facebook_events_ids": facebookEventIds}),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return json.decode(result.body)["success"] == true;
  }

  Future<MarketModel> getOne(int marektId) async {
    final result = await http.get(
      'https://targowisko.herokuapp.com/api/v1/markets/$marektId',
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return MarketModel.fromJson(json.decode(result.body));
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

  Future<bool> rate({
    @required int productId,
    @required int rating,
    @required String comment,
  }) async {
    final result = await http.post(
        'https://targowisko.herokuapp.com/api/v1/products/${productId}/rate.json',
        headers: {
          'access-token': Api.accesToken,
        },
        body: <String, dynamic>{
          "rating": rating,
          "comment": comment,
        });

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return true;
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
