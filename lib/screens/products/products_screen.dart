import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:targowisko/models/product_model.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';
import 'package:targowisko/widgets/list_item/list_item.dart';
import 'package:targowisko/widgets/list_item/widgets/list_item_picture.dart';
import 'package:targowisko/widgets/search_input/search_input.dart';

import '../../routes.dart';

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
  bool _isFetchingNext = false;

  List<ProductModel> _products = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts(pageNumber: _initialPageNumber, perPage: _perPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts({
    @required int pageNumber,
    @required int perPage,
    String searchPhrase,
  }) async {
    if (_loading) return;
    try {
      setState(() {
        _loading = true;
        if (pageNumber != _initialPageNumber) _isFetchingNext = true;
      });
      final products = await Api.product.fetch(
        pageNumber: pageNumber,
        perPage: perPage,
        searchValue: searchPhrase,
      );
      setState(() {
        _loading = false;
        _isFetchingNext = false;
        _currentPage = pageNumber;
        _canFetch = perPage == products.length;
        if (pageNumber == _initialPageNumber) {
          _products = products;
        } else {
          _products.addAll(products);
        }
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

  Future<void> _onSearch() async {
    await _fetchProducts(
      pageNumber: _initialPageNumber,
      perPage: _perPage,
      searchPhrase: _controller.text,
    );
  }

  double _getTopPadding(BuildContext context) =>
      MediaQuery.of(context).padding?.top ?? 0;

  void _openProductScreen(ProductModel product) async {
    await Navigator.pushNamed(context, Routes.product, arguments: product);
    setState(() {});
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
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: SearchInput(
              controller: _controller,
              topPadding: _getTopPadding(context),
              onSearch: _onSearch,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == _products.length) {
                    _fetchNext();
                    return _loading && _isFetchingNext
                        ? Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 15),
                            child: CircularProgressIndicator())
                        : SizedBox();
                  }

                  final product = _products[index];
                  final rating = product.averageRating;

                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: !_isFetchingNext && _loading ? 0.5 : 1,
                    child: ListItem(
                      title: product.name,
                      description: product.description,
                      averageRating: rating,
                      onTap: () => _openProductScreen(product),
                      child: ListItemPicture(
                        imageUrl: product.picture,
                      ),
                    ),
                  );
                },
                childCount: _products.length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
