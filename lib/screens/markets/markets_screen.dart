import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/nav_bar.dart';

class MarketsScreen extends StatefulWidget {
  @override
  _MarketsScreenState createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StyleProvider.of(context).colors.primaryBackground,
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
              NavBar(
                title: "Targi",
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: StyleProvider.of(context).colors.primaryBackground,
                    ),
                    child: ListView(
                      children: <Widget>[],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
