import 'package:flutter/material.dart';
import 'package:targowisko/screens/market/widgets/icon_section.dart';
import 'package:targowisko/screens/market/widgets/organiser_section.dart';
import 'package:targowisko/screens/market/widgets/section.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/card_slider.dart';
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
  @override
  Widget build(BuildContext context) {
    final market = widget.args.market;
    return ExtentListScaffold(
      // TODO:
      liked: false,
      // TODO:
      onLikePress: () {},
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
            child: Container(
              height: 200,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
