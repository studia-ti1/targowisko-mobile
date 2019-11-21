import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class CardSlider extends StatefulWidget {
  @override
  _CardSliderState createState() => _CardSliderState();
}

class _CardSliderState extends State<CardSlider> {
  static const _cardWidthFactor = 0.8;
  PageController _controller = PageController(
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
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, snapshot) {
                final cardWidth = constraints.maxWidth * _cardWidthFactor;
                final value =
                    ((index * cardWidth - _controller.offset).abs() / cardWidth)
                        .clamp(0.0, 1.0);

                final scale = Tween(begin: 1.0, end: .85).transform(value);
                final opacity = Tween(begin: .25, end: .15).transform(value);
                final offset = Tween(begin: 4.0, end: 0.0).transform(value);

                return Center(
                  child: Transform.scale(
                    scale: scale,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, opacity),
                              offset: Offset(offset, offset),
                              blurRadius: 6,
                            ),
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          // width: cardWidth,
                          decoration: BoxDecoration(
                            gradient: StyleProvider.of(context)
                                .gradient
                                .cardGradient3,
                          ),
                          height: 150,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
