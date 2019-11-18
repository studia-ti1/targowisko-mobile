import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class NavBar extends StatelessWidget {
  final String title;
  final double shrinkOffset;
  final double maxExtent;
  final double minExtent;

  NavBar({
    @required this.title,
    @required this.shrinkOffset,
    @required this.maxExtent,
    @required this.minExtent,
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin:
          EdgeInsets.only(top: (MediaQuery.of(context).padding?.top ?? 0) + 5),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Material(
                color: Colors.transparent,
                child: BackButton(
                  color: StyleProvider.of(context).colors.primaryBackground,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, maxExtent - shrinkOffset - 10),
            child: Align(
              alignment: Alignment(-(shrinkOffset / maxExtent), 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 55),
                child: Text(
                  title,
                  style: StyleProvider.of(context)
                      .font
                      .pacificoPrimary
                      .copyWith(fontSize: 25),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
