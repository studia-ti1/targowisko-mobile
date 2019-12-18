import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/models/product_model.dart';
import 'package:targowisko/screens/home/widgets/market_card.dart';
import 'package:targowisko/screens/market/widgets/organiser_section.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/animated/animated_rating_coins.dart';
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
