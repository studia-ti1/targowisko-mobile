import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/models/product_model.dart';
import 'package:targowisko/screens/home/home_screen.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/widgets/list_item/list_item.dart';
import 'package:targowisko/widgets/list_item/widgets/list_item_picture.dart';
import 'package:targowisko/widgets/list_scaffold.dart';

class ChooseProducts extends StatefulWidget {
  final MarketModel market;

  ChooseProducts({@required this.market});

  @override
  ChooseProductsState createState() => ChooseProductsState();
}

class ChooseProductsState extends State<ChooseProducts> {
  List<ProductModel> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      setState(() {
        _loading = true;
      });
      _products = await Api.product.fetch(
        userId: Api.currentUser.id,
      );

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

  void _addProductToMarket(ProductModel product) async {
    final status = await Alert.open(
      context,
      title: "Wystawianie produktu",
      confirmLabel: "Wystaw!",
      cancelLabel: "Rozmyśliłem się 😒",
      content: "Czy chcesz wystawić produkt ${product.name} "
          "na targu ${widget.market.name}?",
      withStackTrace: false,
    );

    if (status) {
      Alert.loader(context, "Wystawianie produktu...");
      try {
        await Api.addProductToMarket(product.id, widget.market.id);

        widget.market.products.add(product);
        widget.market.sellers.firstWhere(
            (seller) => seller.id == Api.currentUser.id, orElse: () {
          widget.market.sellers.add(Api.currentUser);
          return null;
        });
      } on ApiException catch (err) {
        Navigator.pop(context);
        Alert.open(
          context,
          title: "Wystąpił nieoczekiwany błąd",
          content: err.message,
        );
        return;
      }
      Navigator.pop(context);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListScaffold(
        title: "Wystaw produkty",
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _loading
              ? Center(
                  child: CustomLoader(
                    loadingText: "Wyszukiwanie twoich produktów",
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  itemCount: _products.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = _products[index];
                    return ListItem(
                      title: product.name,
                      description: product.description,
                      averageRating: product.averageRating,
                      onTap: () => _addProductToMarket(product),
                      child: ListItemPicture(
                        imageUrl: product.picture,
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
