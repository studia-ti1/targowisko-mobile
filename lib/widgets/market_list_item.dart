import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/utils/style_provider.dart';

class MarketListItem extends StatelessWidget {
  final MarketModel market;

  MarketListItem({
    @required this.market,
  }) : assert(market != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 110,
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: StyleProvider.of(context).colors.primaryAccent,
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                width: 110,
                height: 110,
                imageUrl: market.imageUrl,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  market.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StyleProvider.of(context)
                      .font
                      .pacifico
                      .copyWith(fontSize: 20),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: Text(
                    market.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: StyleProvider.of(context)
                        .font
                        .normal
                        .copyWith(fontSize: 12, height: 1.3),
                  ),
                ),
                SizedBox(height: 5),
                // TODO:
                Container(
                  height: 20,
                  width: 200,
                  color: Colors.red,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
