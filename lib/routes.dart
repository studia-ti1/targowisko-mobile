import 'package:flutter/material.dart';
import 'package:targowisko/screens/add_market/add_market_screen.dart';
import 'package:targowisko/screens/add_product/add_product.dart';

import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/market/market_screen.dart';
import 'screens/markets/markets_screen.dart';
import 'screens/products/products_screen.dart';
import 'screens/sellers/sellers_screen.dart';

class Routes {
  static const String login = '/';
  static const String home = '/home';
  static const String markets = '/markets';
  static const String market = '/market';
  static const String products = '/products';
  static const String sellers = '/sellers';
  static const String addProduct = '/product/add';
  static const String addMarket = '/market/add';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute<void>(builder: (_) => HomeScreen());
      case login:
        return MaterialPageRoute<void>(builder: (_) => LoginScreen());
      case markets:
        return MaterialPageRoute<void>(builder: (_) => MarketsScreen());
      case market:
        assert(settings.arguments != null &&
            settings.arguments is MarketScreenArgs);
        MarketScreenArgs args = settings.arguments;
        return MaterialPageRoute<void>(
          builder: (_) => MarketScreen(args: args),
        );
      case products:
        return MaterialPageRoute<void>(builder: (_) => ProductsScreen());
      case sellers:
        return MaterialPageRoute<void>(builder: (_) => SellersScreen());
      case addProduct:
        return MaterialPageRoute<void>(builder: (_) => AddProductScreen());
      case addMarket:
        return MaterialPageRoute<void>(builder: (_) => AddMarketScreen());
      default:
        return MaterialPageRoute<void>(builder: (_) => LoginScreen());
    }
  }
}
