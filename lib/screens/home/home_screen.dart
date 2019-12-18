import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/models/owner_model.dart';
import 'package:targowisko/models/product_model.dart';
import 'package:targowisko/screens/home/widgets/market_card.dart';
import 'package:targowisko/screens/home/widgets/scaffold_with_menu.dart';
import 'package:targowisko/screens/market/market_screen.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/avatar.dart';
import 'package:targowisko/widgets/sliders/element_slider.dart';

import '../../routes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MarketModel> _markets = [];
  List<ProductModel> _products = [];
  List<OwnerModel> _sellers = [];
  bool _loading = true;
  OwnerModel user;
  String _loadingText = "";

  @override
  void initState() {
    try {
      _fetchMarkets();
    } on ApiException catch (err) {
      Alert.open(
        context,
        title: "Wystąpił nieoczekiwany bład",
        content: err.message,
      );
      super.initState();
    }
  }

  Future<void> _fetchMarkets() async {
    setState(() {
      _loading = true;
      _loadingText = "Sprawdzamy kim jesteś...";
    });
    try {
      user = await Api.getAboutMe();
      setState(() {
        _loadingText = "Poszukujemy najlpeszych marketów...";
      });
      _markets = await Api.market.fetch(pageNumber: 1, perPage: 5);
      setState(() {
        _loadingText = "Testujemy jakość produktów...";
      });
      _products = await Api.product.fetch(pageNumber: 2, perPage: 10);
      setState(() {
        _loadingText = "Weryfikujemy najlepszych sprzedawców...";
      });
      _sellers = await Api.fetchUsers();
    } on ApiException catch (err) {
      Alert.open(context, title: "Wystąpił błąd", content: err.message);
      return;
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        child: _loading
            ? Scaffold(
                backgroundColor: Colors.white,
                body: CustomLoader(loadingText: _loadingText),
              )
            : ScaffoldWithMenu(
                builder: ({openMenu, closeMenu}) => ListView(
                  children: <Widget>[
                    if (user != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: <Widget>[
                            Avatar(
                              nickname: user.firstName,
                              imageUrl: user.avatar,
                              size: 60,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "Witaj ${user.firstName}!",
                                  style: StyleProvider.of(context)
                                      .font
                                      .pacifico
                                      .copyWith(fontSize: 25),
                                ),
                                Text(
                                  "Dzisiaj jest dobry dzień na zakupy!",
                                  style: StyleProvider.of(context)
                                      .font
                                      .normal
                                      .copyWith(
                                          color: StyleProvider.of(context)
                                              .colors
                                              .content
                                              .withOpacity(0.5)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ElementSlider<ProductModel>(
                      cardWidth: 130,
                      title: "Najpopularniejsze produkty",
                      elementBuilder: (context, product) => ProductCard(
                        product: product,
                        onTap: () => Navigator.pushNamed(
                          context,
                          Routes.product,
                          arguments: product,
                        ),
                      ),
                      items: _products,
                    ),
                    ElementSlider<MarketModel>(
                      title: "Najpopularniejsze targi",
                      elementBuilder: (context, market) =>
                          MarketCard(market: market),
                      items: _markets,
                    ),
                    ElementSlider<OwnerModel>(
                      cardWidth: 350,
                      title: "Najpopularniejsi sprzedawcy",
                      elementBuilder: (context, seller) => Material(
                        color: Colors.transparent,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                gradient: StyleProvider.of(context)
                                    .gradient
                                    .cardGradient3,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: SellerCardContent(
                                avatarUrl: seller.avatar,
                                productsCount: seller.products.length,
                                rating: seller.averageRating,
                                sellerName:
                                    "${seller.firstName} ${seller.lastName}",
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.white24,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.seller,
                                    arguments: seller,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      items: _sellers,
                    ),
                  ],
                ),
              ),
        duration: const Duration(seconds: 1),
        switchInCurve: Curves.easeIn,
      ),
    );
  }
}

class CustomLoader extends StatelessWidget {
  const CustomLoader({
    Key key,
    @required String loadingText,
  })  : _loadingText = loadingText,
        super(key: key);

  final String _loadingText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              StyleProvider.of(context).asset.spinner,
              width: 100,
              fit: BoxFit.contain,
              color: Colors.black,
              colorBlendMode: BlendMode.color,
              repeat: ImageRepeat.noRepeat,
              filterQuality: FilterQuality.medium,
              height: 100,
            ),
            SizedBox(height: 15),
            AutoSizeText(
              _loadingText,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: StyleProvider.of(context)
                  .font
                  .pacifico
                  .copyWith(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
