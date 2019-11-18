import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:targowisko/models/product_model.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';
import 'package:targowisko/widgets/list_item/list_item.dart';
import 'package:targowisko/widgets/list_item/widgets/list_item_picture.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  static const _initialPageNumber = 1;
  static const _perPage = 10;
  int _currentPage = _initialPageNumber;
  bool _canFetch = true;
  bool _loading = false;

  final List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts(pageNumber: _initialPageNumber, perPage: _perPage);
  }

  Future<void> _fetchProducts({
    @required int pageNumber,
    @required int perPage,
  }) async {
    if (_loading || !_canFetch) return;
    try {
      setState(() {
        _loading = true;
      });
      final products = await Api.product.fetch(
        pageNumber: pageNumber,
        perPage: perPage,
      );
      setState(() {
        _loading = false;
        _currentPage = pageNumber;
        _canFetch = perPage == products.length;
        _products.addAll(products);
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

  void _fetchNext() {
    if (_loading || !_canFetch) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fetchProducts(pageNumber: ++_currentPage, perPage: _perPage);
    });
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
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(15, 40, 15, 10),
        itemBuilder: (BuildContext context, int index) {
          if (index == _products.length) {
            _fetchNext();
            return _loading
                ? Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 15),
                    child: CircularProgressIndicator())
                : SizedBox();
          }

          final product = _products[index];
          return ListItem(
            title: product.name,
            description: product.description,
            averageRating: product.averageRating,
            // TODO:
            onTap: () {},
            child: ListItemPicture(
              imageUrl: product.picture,
            ),
          );
        },
        itemCount: _products.length + 1,
      ),
    );
  }
}
