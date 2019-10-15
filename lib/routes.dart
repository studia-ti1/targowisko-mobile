import 'package:flutter/material.dart';
import 'package:targowisko/screens/login/login.dart';

class Routes {
  static const String home = '/';
  static const String loginScreen = '/login';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute<void>(builder: (_) => LoginScreen());
      case loginScreen:
        return MaterialPageRoute<void>(builder: (_) => LoginScreen());
      default:
        return MaterialPageRoute<void>(builder: (_) => LoginScreen());
    }
  }
}
