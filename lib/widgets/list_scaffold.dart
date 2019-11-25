import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

import 'nav_bar.dart';

class ListScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  ListScaffold({
    @required this.title,
    @required this.child,
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 400,
            decoration: BoxDecoration(
              gradient: StyleProvider.of(context).gradient.cardGradient2,
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: 100,
                child: NavBar(
                  title: title,
                  shrinkOffset: 70,
                  maxExtent: 70,
                  minExtent: 70,
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    color: StyleProvider.of(context).colors.primaryBackground,
                    child: child,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
