import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';

class MarketsScreen extends StatefulWidget {
  @override
  _MarketsScreenState createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  @override
  Widget build(BuildContext context) {
    return ExtentListScaffold(
      title: "Targi",
      navChild: Image.asset(
        StyleProvider.of(context).asset.targIcon,
        width: 100,
        height: 100,
      ),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Text(
            index.toString(),
            style: StyleProvider.of(context)
                .font
                .pacifico
                .copyWith(color: Colors.black),
          );
        },
      ),
    );
  }
}
