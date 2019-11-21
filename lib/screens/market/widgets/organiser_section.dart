import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/avatar.dart';

class OrganiserSection extends StatelessWidget {
  final MarketModel market;

  OrganiserSection({
    @required this.market,
  }) : assert(market != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Row(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Avatar(
              // TODO:
              imageUrl: null,
              size: 60,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              children: <Widget>[
                AutoSizeText(
                  market.name,
                  style: StyleProvider.of(context)
                      .font
                      .pacifico
                      .copyWith(fontSize: 25),
                  maxLines: 1,
                  minFontSize: 15,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  market.description,
                  style: StyleProvider.of(context)
                      .font
                      .normal
                      .copyWith(fontSize: 13),
                  maxLines: 5,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
