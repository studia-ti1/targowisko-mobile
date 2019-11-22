import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class CardsSliderCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback onCardPress;

  CardsSliderCard({
    @required this.child,
    @required this.padding,
    @required this.onCardPress,
  }) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: StyleProvider.of(context).gradient.cardGradient3,
      ),
      height: 150,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor:
              StyleProvider.of(context).colors.primaryContent.withOpacity(0.3),
          onTap: onCardPress,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
