import 'package:cached_network_image/cached_network_image.dart';
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
    return Stack(
      children: <Widget>[
        FadeInImage(
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(market.imageUrl),
          placeholder: AssetImage(
            StyleProvider.of(context).asset.marketDefaultBackground,
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
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
      ],
    );
  }
}
