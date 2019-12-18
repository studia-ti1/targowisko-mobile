import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/models/product_model.dart';
import 'package:targowisko/models/rating_model.dart';
import 'package:targowisko/screens/home/widgets/market_card.dart';
import 'package:targowisko/screens/market/widgets/organiser_section.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/animated/animated_rating_coins.dart';
import 'package:targowisko/widgets/buttons/rounded_button.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';
import 'package:targowisko/widgets/extent_list_scaffold_image_nav_child.dart';
import 'package:targowisko/widgets/sliders/element_slider.dart';

class ProductScreen extends StatefulWidget {
  final ProductModel product;

  ProductScreen({
    @required this.product,
  });

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return ExtentListScaffold(
      navChild: widget.product.picture == null
          ? Image.asset(
              StyleProvider.of(context).asset.productIcon,
              width: 100,
              height: 100,
            )
          : ExtentListScaffoldImageNavChild(
              imageUrl: widget.product.picture,
            ),
      title: widget.product.name,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: OrganiserSection(
              role: "Sprzedawca",
              owner: widget.product.owner,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: Row(
              children: <Widget>[
                AnimatedRatingCoins(
                  raiting: widget.product.averageRating,
                  delay: const Duration(milliseconds: 300),
                ),
                Spacer(),
                RoundedButton(
                  height: 40,
                  title: "Oceń",
                  fontSize: 18,
                  onTap: () {
                    Alert.openRateModal(
                      context,
                      title: "Oceń produkt",
                      onRate: (Rate rate) async {
                        final product = widget.product;
                        final result = await Api.product.rate(
                          comment: rate.comment,
                          rating: rate.rate,
                          productId: product.id,
                        );

                        if (result == true) {
                          product.productRatings.add(RatingModel(
                            comment: rate.comment,
                            createdAt: DateTime.now(),
                            id: Random().nextInt(20000),
                            marketId: null,
                            rating: rate.rate,
                            updatedAt: null,
                            userId: Api.currentUser.id,
                          ));
                          var avg = product.productRatings
                                  .map((m) => m.rating)
                                  .reduce((a, b) => a + b) /
                              product.productRatings.length;
                          product.averageRating = avg;
                          setState(() {});
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Kategoria:",
              style: StyleProvider.of(context)
                  .font
                  .pacifico
                  .copyWith(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(widget.product.getCateogry().assetName),
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    SizedBox.expand(
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.black26),
                      ),
                    ),
                    Center(
                      child: AutoSizeText(
                        widget.product.getCateogry().name,
                        maxLines: 1,
                        style: StyleProvider.of(context)
                            .font
                            .pacificoPrimary
                            .copyWith(fontSize: 26),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Cena:",
              style: StyleProvider.of(context)
                  .font
                  .pacifico
                  .copyWith(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: Text(
              "${(widget.product.price / 100).toStringAsFixed(2)} zł",
              style: StyleProvider.of(context).font.normal,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Opis:",
              style: StyleProvider.of(context)
                  .font
                  .pacifico
                  .copyWith(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: Text(
              widget.product.description ?? "-",
              style: StyleProvider.of(context).font.normal,
            ),
          ),
          if (widget.product.markets != null)
            widget.product.markets.isNotEmpty
                ? ElementSlider<MarketModel>(
                    title: "Dostępność na targach:",
                    elementBuilder: (context, market) => MarketCard(
                      market: market,
                      enabled: false,
                    ),
                    items: widget.product.markets,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Dostępność na targach:",
                          style: StyleProvider.of(context)
                              .font
                              .pacifico
                              .copyWith(fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Produkt aktualnie nie dostępny na żadnym targu",
                          style: StyleProvider.of(context).font.normal,
                        ),
                      ),
                    ],
                  ),
        ],
      ),
    );
  }
}
