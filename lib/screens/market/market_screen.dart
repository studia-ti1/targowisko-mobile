import 'package:flutter/material.dart';
import 'package:targowisko/screens/market/widgets/organiser_section.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/widgets/extent_list_scaffold_image_nav_child.dart';

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
      title: market.name,
      navChild: ExtentListScaffoldImageNavChild(
        imageUrl: market.imageUrl,
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
        children: <Widget>[
          OrganiserSection(
            market: market,
          ),
        ],
      ),
    );
  }
}
