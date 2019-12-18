import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/screens/market/market_screen.dart';
import 'package:targowisko/utils/style_provider.dart';

import '../../../routes.dart';

class MarketCard extends StatelessWidget {
  const MarketCard({
    @required this.market,
    this.enabled = true,
  });

  final MarketModel market;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          imageUrl: market.imageUrl,
        ),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black54, Colors.black12],
            ),
          ),
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
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled
                ? () {
                    Navigator.pushNamed(
                      context,
                      Routes.market,
                      arguments: MarketScreenArgs(market: market),
                    );
                  }
                : null,
          ),
        )
      ],
    );
  }
}
