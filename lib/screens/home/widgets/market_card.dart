import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/utils/style_provider.dart';

class MarketCard extends StatelessWidget {
  const MarketCard({
    @required this.market,
  });

  final MarketModel market;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            market.name,
            style: StyleProvider.of(context)
                .font
                .pacificoPrimary
                .copyWith(fontSize: 18),
          )
        ],
      ),
    );
  }
}
