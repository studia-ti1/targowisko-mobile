import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/models/owner_model.dart';
import 'package:targowisko/models/product_model.dart';
import 'package:targowisko/models/rating_model.dart';
import 'package:targowisko/screens/add_market/add_market_screen.dart';
import 'package:targowisko/screens/add_product/add_product.dart';
import 'package:targowisko/screens/choose_products/choose_products_screen.dart';
import 'package:targowisko/screens/market_products/market_products_screen.dart';
import 'package:targowisko/screens/product/product_screen.dart';
import 'package:targowisko/screens/ratings_screen/ratings_screen.dart';
import 'package:targowisko/screens/seller/seller_screen.dart';
import 'package:targowisko/screens/user/user_screen.dart';

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
  static const String product = '/product';
  static const String products = '/products';
  static const String sellers = '/sellers';
  static const String seller = '/seller';
  static const String addProduct = '/product/add';
  static const String addMarket = '/market/add';
  static const String marketProducts = '/market/products';
  static const String ratingsScreen = '/ratings';
  static const String me = '/me';
  static const String choose = '/choose_products';

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

      case me:
        return MaterialPageRoute<void>(builder: (_) => UserScreen());

      case choose:
        assert(settings.arguments != null && settings.arguments is MarketModel);

        MarketModel market = settings.arguments;

        return MaterialPageRoute<void>(
          builder: (_) => ChooseProducts(
            market: market,
          ),
        );

      case ratingsScreen:
        assert(settings.arguments != null && settings.arguments is List<RatingModel>);

        List<RatingModel> ratings = settings.arguments;

        return MaterialPageRoute<void>(
          builder: (_) => RatingsScreen(
            ratings: ratings,
          ),
        );

      case seller:
        assert(settings.arguments != null && settings.arguments is OwnerModel);

        OwnerModel sellerModel = settings.arguments;

        return MaterialPageRoute<void>(
          builder: (_) => SellerScreen(
            seller: sellerModel,
          ),
        );

      case marketProducts:
        assert(settings.arguments != null && settings.arguments is MarketModel);

        MarketModel market = settings.arguments;

        return MaterialPageRoute<void>(
          builder: (_) => MarketProductsScreen(
            market: market,
          ),
        );

      case product:
        assert(
            settings.arguments != null && settings.arguments is ProductModel);

        ProductModel product = settings.arguments;

        return MaterialPageRoute<void>(
          builder: (_) => ProductScreen(product: product),
        );

      default:
        return MaterialPageRoute<void>(
          builder: (_) => LoginScreen(),
        );
    }
  }
}
