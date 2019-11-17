import 'package:flutter/material.dart';
import 'package:targowisko/screens/home/home_screen.dart';
import 'package:targowisko/screens/login/login_screen.dart';
import 'package:targowisko/screens/markets/markets_screen.dart';

class Routes {
  static const String home = '/home';
  static const String markets = '/markets';
  static const String login = '/';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute<void>(builder: (_) => HomeScreen());
      case login:
        return MaterialPageRoute<void>(builder: (_) => LoginScreen());
      case markets:
        return MaterialPageRoute<void>(builder: (_) => MarketsScreen());
      default:
        return MaterialPageRoute<void>(builder: (_) => LoginScreen());
    }
  }
}
