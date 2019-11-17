import 'dart:convert';
import 'dart:io';

import 'package:targowisko/utils/api.dart';

import 'location_model.dart';
import 'owner_model.dart';

import 'package:http/http.dart' as http;

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

  
}
