import 'package:flutter/material.dart';
import 'package:targowisko/screens/home/home_screen.dart';
import 'package:targowisko/screens/login/login_screen.dart';

class Routes {
  static const String home = '/home';
  static const String loginScreen = '/';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute<void>(builder: (_) => HomeScreen());
      case loginScreen:
        return MaterialPageRoute<void>(builder: (_) => LoginScreen());
      default:
        return MaterialPageRoute<void>(builder: (_) => LoginScreen());
    }
  }
}
