import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:targowisko/models/owner_model.dart';
import 'package:targowisko/models/product_model.dart';
import 'package:targowisko/screens/market/market_screen.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/animated/animated_rating_coins.dart';
import 'package:targowisko/widgets/avatar.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';
import 'package:targowisko/widgets/sliders/element_slider.dart';

import '../../routes.dart';

class SellerScreen extends StatefulWidget {
  final OwnerModel seller;

  SellerScreen({
    @required this.seller,
  });

  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  @override
  void initState() {
    print(widget.seller.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExtentListScaffold(
      navChild: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Avatar(
          imageUrl: widget.seller.avatar,
          size: 100,
          nickname: widget.seller.firstName,
        ),
      ),
      title: widget.seller.firstName + " " + widget.seller.lastName,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: Row(
              children: <Widget>[
                AnimatedRatingCoins(
                  raiting: widget.seller.averageRating,
                  delay: const Duration(milliseconds: 300),
                ),
                Spacer(),
                FlatButton(
                  color: StyleProvider.of(context).colors.primaryAccent,
                  child: Text(
                    "Więcej",
                    style: StyleProvider.of(context).font.pacificoPrimary,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Kontakt:",
              style: StyleProvider.of(context)
                  .font
                  .pacifico
                  .copyWith(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: Text(
              widget.seller.email ?? "-",
              style: StyleProvider.of(context).font.normal,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Wystawionych produktów:",
              style: StyleProvider.of(context)
                  .font
                  .pacifico
                  .copyWith(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: Text(
              widget.seller.productsCount.toString() ?? "-",
              style: StyleProvider.of(context).font.normal,
            ),
          ),
          ElementSlider<ProductModel>(
            cardWidth: 130,
            title: "Produkty",
            elementBuilder: (context, product) => ProductCard(
              product: product,
              onTap: () => Navigator.pushNamed(
                context,
                Routes.product,
                arguments: product,
              ),
            ),
            items: widget.seller.products,
          ),
        ],
      ),
    );
  }
}
