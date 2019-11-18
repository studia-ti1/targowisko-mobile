import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    // Api.
  }

  @override
  Widget build(BuildContext context) {
    return ExtentListScaffold(
      title: "Produkty",
      navChild: Image.asset(
        StyleProvider.of(context).asset.productIcon,
        width: 100,
        height: 100,
      ),
      child: ListView(
        children: <Widget>[],
      ),
    );
  }
}
