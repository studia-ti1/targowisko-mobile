import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/raiting_coins.dart';

class MarketListItem extends StatelessWidget {
  final MarketModel market;
  final Widget child;

  MarketListItem({@required this.market, @required this.child})
      : assert(market != null);

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
              child: child,
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
                  child: RaitingCoins(
                    value: 4.5,
                    size: 20,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
