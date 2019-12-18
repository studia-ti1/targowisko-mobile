import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/models/product_model.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/widgets/list_item/list_item.dart';
import 'package:targowisko/widgets/list_item/widgets/list_item_picture.dart';
import 'package:targowisko/widgets/list_scaffold.dart';

import '../../routes.dart';

class MarketProductsScreen extends StatefulWidget {
  final MarketModel market;

  MarketProductsScreen({@required this.market});

  @override
  MarketProductsScreenState createState() => MarketProductsScreenState();
}

class MarketProductsScreenState extends State<MarketProductsScreen> {
  List<ProductModel> _products = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    if (_loading) return;
    try {
      setState(() {
        _loading = true;
      });
      _products = await Api.product.fetch(marketId: widget.market.id);

      setState(() {
        _loading = false;
      });
    } on ApiException catch (err) {
      Alert.open(
        context,
        title: "Wystąpił nieoczekiwany błąd",
        content: err.message,
        onConfirm: Navigator.of(context).pop,
        confirmLabel: "Rozumiem",
      );
    }
  }

  void _openProductScreen(ProductModel product) async {
    Navigator.pushNamed(context, Routes.product, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return ListScaffold(
      title: widget.market.name,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        itemCount: _products.length,
        itemBuilder: (BuildContext context, int index) {
          final product = _products[index];
          return ListItem(
            title: product.name,
            description: product.description,
            averageRating: product.averageRating,
            onTap: () => _openProductScreen(product),
            child: ListItemPicture(
              imageUrl: product.picture,
            ),
          );
        },
      ),
    );
  }
}
