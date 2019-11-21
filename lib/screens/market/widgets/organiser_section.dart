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
      child: Row(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Avatar(
                // TODO:
                imageUrl: null,
                size: 60,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AutoSizeText(
                  market.owner?.fullName ?? "Nieznany",
                  style: StyleProvider.of(context)
                      .font
                      .pacifico
                      .copyWith(fontSize: 25),
                  maxLines: 1,
                  minFontSize: 15,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  "Organizator",
                  style: StyleProvider.of(context)
                      .font
                      .normal
                      .copyWith(fontSize: 14),
                  maxLines: 1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
