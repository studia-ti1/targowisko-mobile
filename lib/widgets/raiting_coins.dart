import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class RaitingCoins extends StatelessWidget {
  final double size;
  final double value;
  final bool withText;
  final ValueChanged<int> onCoinPress;
  final MainAxisAlignment mainAxisAlignment;

  RaitingCoins({
    @required this.size,
    @required this.value,
    this.mainAxisAlignment,
    this.onCoinPress,
    this.withText = true,
  }) : assert(size != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Material(
                  borderRadius: BorderRadius.circular(size),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(size),
                    onTap: onCoinPress != null
                        ? () => onCoinPress(index + 1)
                        : null,
                    child: Coin(
                      size: size,
                      value: ((value ?? 0.0) - index).clamp(0.0, 1.0),
                    ),
                  ),
                ),
              );
            },
            scrollDirection: Axis.horizontal,
            itemCount: 5,
          ),
          if (withText) const SizedBox(width: 5),
          if (withText)
            Text(
              value == null ? "-" : value.toStringAsFixed(1),
              style:
                  StyleProvider.of(context).font.normal.copyWith(fontSize: 14),
            )
        ],
      ),
    );
  }
}

class Coin extends StatelessWidget {
  final double size;
  final double value;

  Coin({
    @required this.size,
    @required this.value,
  }) : assert(size != null && value != null && value >= 0 && value <= 1);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: <Widget>[
            Container(
              height: size,
              width: value * size,
              color: StyleProvider.of(context).colors.coin,
            ),
            Image.asset(
              StyleProvider.of(context).asset.coin,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
