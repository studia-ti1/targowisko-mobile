import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:targowisko/screens/market/widgets/icon_section.dart';
import 'package:targowisko/screens/market/widgets/organiser_section.dart';
import 'package:targowisko/screens/market/widgets/section.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/avatar.dart';
import 'package:targowisko/widgets/cards_slider/cards_slider.dart';
import 'package:targowisko/widgets/cards_slider/widget/card_slider_card.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/widgets/extent_list_scaffold_image_nav_child.dart';
import 'package:targowisko/widgets/raiting_coins.dart';

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
  // TODO;
  bool _isLiked = false;

  void _likeMarket() {
    // TODO:
  }

  void _openSellerScreen() {
    // TODO;
  }

  @override
  Widget build(BuildContext context) {
    final market = widget.args.market;
    return ExtentListScaffold(
      liked: _isLiked,
      onLikePress: _likeMarket,
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
              market: market,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: RaitingCoins(
              size: 35,
              value: market.averageRating,
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
            // TODO:
            child: CardsSlider(
              child: CardsSliderCard(
                onCardPress: _openSellerScreen,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: SellerCardContent(
                  // TODO:
                  avatarUrl:
                      "https://images.unsplash.com/photo-1524593689594-aae2f26b75ab?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1300&q=80",
                  sellerName: "Monika Nowak",
                  productsCount: 16,
                  rating: 3.4,
                ),
              ),
            ),
          )
        ],
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
