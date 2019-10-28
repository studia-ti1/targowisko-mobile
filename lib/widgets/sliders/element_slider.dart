import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/section_title.dart';

typedef SliderElementBuilder<T> = Widget Function(BuildContext context, T item);

class ElementSlider<T> extends StatelessWidget {
  final String title;
  final double height;
  final double cardWidth;
  final List<T> items;
  final SliderElementBuilder<T> elementBuilder;

  ElementSlider({
    @required this.title,
    @required this.items,
    @required this.elementBuilder,
    this.cardWidth = 300,
    this.height = 250,
  })  : assert(items != null),
        assert(elementBuilder != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      height: height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionTitle(
            title: title,
          ),
          Expanded(
            child: ListView.separated(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.all(15),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return SliderCard(
                  width: cardWidth,
                  child: elementBuilder(context, items[index]),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(width: 15),
              itemCount: items.length,
            ),
          )
        ],
      ),
    );
  }
}

class SliderCard extends StatelessWidget {
  final double width;
  final Widget child;

  SliderCard({
    @required this.width,
    @required this.child,
  })  : assert(width != null),
        assert(child != null);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: width,
        color: StyleProvider.of(context).colors.primaryAccent,
        child: child,
      ),
    );
  }
}
