import 'package:flutter/material.dart';

typedef SliderBuilder = Widget Function(BuildContext context, int index);

class CardsSlider extends StatefulWidget {
  final SliderBuilder builder;
  final int itemsCount;

  CardsSlider({
    @required this.builder,
    @required this.itemsCount,
  })  : assert(builder != null),
        assert(itemsCount != null && itemsCount >= 0);

  @override
  _CardsSliderState createState() => _CardsSliderState();
}

class _CardsSliderState extends State<CardsSlider> {
  static const _cardWidthFactor = 0.8;
  final PageController _controller = PageController(
    viewportFraction: _cardWidthFactor,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width,
      child: LayoutBuilder(builder: (context, constraints) {
        return PageView.builder(
          controller: _controller,
          physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
          itemCount: widget.itemsCount,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, widget) {
                final cardWidth = constraints.maxWidth * _cardWidthFactor;
                final cardFocusFactor =
                    ((index * cardWidth - _controller.offset).abs() / cardWidth)
                        .clamp(0.0, 1.0);

                final curveTween = CurveTween(curve: Curves.easeInOut);

                final scale = Tween(begin: 1.0, end: .85)
                    .chain(curveTween)
                    .transform(cardFocusFactor);
                final opacity = Tween(begin: .25, end: .15)
                    .chain(curveTween)
                    .transform(cardFocusFactor);
                final shadowOffset = Tween(begin: 4.0, end: 0.0)
                    .chain(curveTween)
                    .transform(cardFocusFactor);

                return Center(
                  child: Transform.scale(
                    scale: scale,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, opacity),
                              offset: Offset(shadowOffset, shadowOffset),
                              blurRadius: 6,
                            ),
                          ]),
                      child: widget,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: SizedBox(
                  height: 150,
                  child: widget.builder(context, index),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
