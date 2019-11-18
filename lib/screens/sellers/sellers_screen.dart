import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';

class SellersScreen extends StatefulWidget {
  @override
  _SellersScreenState createState() => _SellersScreenState();
}

class _SellersScreenState extends State<SellersScreen> {
  @override
  Widget build(BuildContext context) {
    return ExtentListScaffold(
      title: "Wystawcy",
      navChild: Image.asset(
        StyleProvider.of(context).asset.sellerIcon,
        width: 100,
        height: 100,
      ),
      child: ListView(
        children: <Widget>[],
      ),
    );
  }
}
