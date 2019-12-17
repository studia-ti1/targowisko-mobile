import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:targowisko/models/product_model.dart';
import 'package:targowisko/routes.dart';
import 'package:targowisko/screens/market/widgets/icon_section.dart';
import 'package:targowisko/screens/market/widgets/organiser_section.dart';
import 'package:targowisko/screens/market/widgets/section.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/animated/animated_rating_coins.dart';
import 'package:targowisko/widgets/avatar.dart';
import 'package:targowisko/widgets/cards_slider/cards_slider.dart';
import 'package:targowisko/widgets/cards_slider/widget/card_slider_card.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/widgets/extent_list_scaffold_image_nav_child.dart';
import 'package:targowisko/widgets/sliders/square_slider.dart';

import '../../routes.dart';

class MarketScreenArgs {
  MarketModel market;

  MarketScreenArgs({
    @required this.market,
  });
}

class MarketScreen extends StatefulWidget {
  final MarketScreenArgs args;

  MarketScreen({@required this.args});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  bool _isLiked = false;
  bool _showLikeButton = true;

  @override
  void initState() {
    _getMarket();
    super.initState();
  }

  Future<MarketModel> _getMarket() async {
    MarketModel market;
    try {
      market = await Api.market.getOne(widget.args.market.id);
    } on ApiException catch (err) {
      await Alert.open(
        context,
        title: "Wystąpił nieoczekiwany błąd",
        content: err.message,
      );
      return null;
    } catch (err) {
      await Alert.open(
        context,
        title: "Wystąpił nieoczekiwany błąd",
        content: err.toString(),
      );
      return null;
    }
    setState(() {
      _showLikeButton = true;
      _isLiked = market.going;
    });
    return market;
  }

  void _likeMarket() async {
    if (_isLiked) return;
    try {
      await Api.attendMarket(widget.args.market.id);
    } on ApiException catch (err) {
      Alert.open(
        context,
        title: "Wystąpił nieoczekiwany błąd",
        content: err.message,
      );
    }
    setState(() {
      _isLiked = true;
    });
  }

  void _openSellerScreen() {
    // TODO;
  }

  void _sellProducts() {
    Navigator.pushNamed(context, Routes.choose);
  }

  @override
  Widget build(BuildContext context) {
    final market = widget.args.market;
    return ExtentListScaffold(
      liked: _isLiked,
      onLikePress: _showLikeButton ? _likeMarket : null,
      title: market?.name ?? "-",
      navChild: ExtentListScaffoldImageNavChild(
        imageUrl: market.imageUrl,
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: OrganiserSection(
              owner: market.owner,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: AnimatedRatingCoins(
              raiting: market.averageRating,
              delay: const Duration(milliseconds: 300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: IconSection(
              icon: Icons.calendar_today,
              // TODO: missing data from /market endpoint
              title: "14 Stycznia 2019",
              content: "2h",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: IconSection(
              icon: Icons.location_on,
              title: market.place?.name ?? "Brak informacji o lokalizacji",
              content: market.place?.location?.locationString ?? "-",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  color: StyleProvider.of(context).colors.primaryAccent,
                  child: Text(
                    "Wystaw produkty",
                    style: StyleProvider.of(context).font.normal.copyWith(
                          fontSize: 13,
                          height: 1,
                          color:
                              StyleProvider.of(context).colors.primaryContent,
                        ),
                  ),
                  onPressed: _sellProducts,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: Section(
              title: "O wydarzeniu",
              child: Text(
                market.description,
                style: StyleProvider.of(context).font.normal.copyWith(
                      fontSize: 13,
                      height: 1,
                    ),
              ),
            ),
          ),
          Section(
            titlePadding:
                const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            title: "Wystawcy",
            onMorePress: () => Navigator.of(context).pushNamed(Routes.sellers),
            // TODO:
            child: CardsSlider(
              itemsCount: market.sellers.length,
              builder: (context, index) => CardsSliderCard(
                onCardPress: _openSellerScreen,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: SellerCardContent(
                  avatarUrl: market.sellers[index].avatar,
                  sellerName: "${market.sellers[index].firstName} "
                      "${market.sellers[index].lastName}",
                  productsCount: 16,
                  rating: 3.4,
                ),
              ),
            ),
          ),
          Section(
            titlePadding:
                const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            title: "Produkty",
            // TODO:
            onMorePress: () {},
            // TODO:
            child: market.products.isEmpty
                ? Center(
                    child: Text(
                      "Ten targ nie posiada produktów",
                      textAlign: TextAlign.center,
                      style: StyleProvider.of(context).font.normal,
                    ),
                  )
                : SquareSlider(
                    itemBuilder: (context, index) {
                      final product = market.products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => Navigator.pushNamed(
                          context,
                          Routes.product,
                          arguments: product,
                        ),
                      );
                    },
                    itemCount: market.products.length,
                  ),
          )
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({
    @required this.product,
    @required this.onTap,
    Key key,
  })  : assert(product != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 150,
        width: 150,
        color: StyleProvider.of(context).colors.primaryAccent,
        child: Stack(
          children: <Widget>[
            if (product.picture != null)
              CachedNetworkImage(
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                imageUrl: product.picture,
              )
            else
              Align(
                alignment: Alignment(0.0, -0.5),
                child: Image.asset(
                  StyleProvider.of(context).asset.productIcon,
                  fit: BoxFit.contain,
                  height: 100,
                  width: 100,
                ),
              ),
            Container(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 5),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black45,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: AutoSizeText(
                product.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: StyleProvider.of(context)
                    .font
                    .pacificoPrimary
                    .copyWith(fontSize: 20),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(onTap: onTap),
            )
          ],
        ),
      ),
    );
  }
}

class SellerCardContent extends StatelessWidget {
  final String sellerName;
  final double rating;
  final int productsCount;
  final String avatarUrl;

  SellerCardContent({
    @required this.sellerName,
    @required this.rating,
    @required this.productsCount,
    @required this.avatarUrl,
  }) : assert(sellerName != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Avatar(
                imageUrl: avatarUrl,
                size: 60,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AutoSizeText(
                    sellerName,
                    minFontSize: 20,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: StyleProvider.of(context)
                        .font
                        .pacificoPrimary
                        .copyWith(fontSize: 25),
                  ),
                  Text(
                    "Wystawca",
                    maxLines: 1,
                    style: StyleProvider.of(context)
                        .font
                        .primaryNormal
                        .copyWith(fontSize: 15),
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Icon(
              Icons.shopping_basket,
              size: 24,
              color: StyleProvider.of(context).colors.primaryContent,
            ),
            SizedBox(width: 10),
            Text(
              "${productsCount == null ? '0' : productsCount} Produktów",
              maxLines: 1,
              style: StyleProvider.of(context).font.primaryNormal,
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Image.asset(
              StyleProvider.of(context).asset.appLogo,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 10),
            Text(
              "Ocena ${rating == null ? '-/-' : rating.toString() + '/5'}",
              maxLines: 1,
              style: StyleProvider.of(context).font.primaryNormal,
            ),
          ],
        )
      ],
    );
  }
}
