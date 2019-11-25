import 'package:flutter/material.dart';

typedef ItemBuilder = Widget Function(BuildContext context, int index);

class SquareSlider extends StatelessWidget {
  final ItemBuilder itemBuilder;
  final int itemCount;
  final double height;

  SquareSlider({
    @required this.itemCount,
    this.height,
    @required this.itemBuilder,
  }) : assert(itemCount != null && itemCount >= 0 && itemBuilder != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 150,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.only(right: 30),
        itemCount: itemCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 30),
            child: itemBuilder(context, index),
          );
        },
      ),
    );
  }
}
