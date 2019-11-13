import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Api {
  /// private constructor
  Api._();

  static String accesToken;

  static Future<http.Response> fetchMarkets() async {
    final result = await http.get(
      'https://targowisko.herokuapp.com/api/v1/markets/',
      headers: {
        'access-token': Api.accesToken,
      },
    );

    if (result.statusCode >= 300) throw ApiException(message: result.body);
    return result;
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
