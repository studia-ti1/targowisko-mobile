import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/models/owner_model.dart';
import 'package:targowisko/screens/home/widgets/market_card.dart';
import 'package:targowisko/screens/home/widgets/scaffold_with_menu.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/avatar.dart';
import 'package:targowisko/widgets/sliders/element_slider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MarketModel> _markets = [];
  bool _loading = true;
  OwnerModel user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      _fetchMarkets();
    } on ApiException catch (err) {
      Alert.open(
        context,
        title: "Wystąpił nieoczekiwany bład",
        content: err.message,
      );
    }
  }

  Future<void> _fetchMarkets() async {
    setState(() {
      _loading = true;
    });
    List<MarketModel> result;
    try {
      user = await Api.getAboutMe();
      result = await Api.market.fetch();
    } on ApiException catch (err) {
      Alert.open(context, title: "Wystąpił błąd", content: err.message);
      return;
    }
    setState(() {
      _markets = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithMenu(
      builder: ({openMenu, closeMenu}) => ListView(
        children: <Widget>[
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: <Widget>[
                  Avatar(
                    nickname: user.firstName,
                    imageUrl: user.avatar,
                    size: 60,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Witaj ${user.firstName}!",
                        style: StyleProvider.of(context)
                            .font
                            .pacifico
                            .copyWith(fontSize: 25),
                      ),
                      Text(
                        "Dzisiaj jest dobry dzień na zakupy!",
                        style: StyleProvider.of(context).font.normal.copyWith(
                            color: StyleProvider.of(context)
                                .colors
                                .content
                                .withOpacity(0.5)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ElementSlider<MarketModel>(
            title: "Najpopularniejsze targi",
            elementBuilder: (context, market) => MarketCard(market: market),
            items: _markets,
          ),
        ],
      ),
    );
  }
}
