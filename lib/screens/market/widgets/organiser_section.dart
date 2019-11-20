import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/widgets/avatar.dart';

class OrganiserSection extends StatelessWidget {
  final MarketModel market;

  OrganiserSection({
    @required this.market,
  }) : assert(market != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        children: <Widget>[
          Avatar(
            // TODO:
            imageUrl: null,
            size: 60,
          ),
          Column(
            children: <Widget>[],
          ),
        ],
      ),
    );
  }
}

