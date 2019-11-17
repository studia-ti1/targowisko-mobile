import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/screens/home/widgets/market_card.dart';
import 'package:targowisko/screens/home/widgets/scaffold_with_menu.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/sliders/element_slider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MarketModel> _markets = [];
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchMarkets();
  }

  Future<void> _fetchMarkets() async {
    setState(() {
      _loading = true;
    });
    http.Response result;
    try {
      result = await Api.fetchMarkets();
    } on ApiException catch (err) {
      Alert.open(context, title: "Wystąpił błąd", content: err.message);
      return;
    }
    setState(() {
      _loading = false;
    });
    final List jsonEventList = jsonDecode(result.body);
    setState(() {
      _markets = jsonEventList.map((dynamic market) {
        return MarketModel.fromJson(market);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithMenu(
      builder: ({openMenu, closeMenu}) => _loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                    StyleProvider.of(context).colors.primaryAccent),
              ),
            )
          : ListView(
              children: <Widget>[
                ElementSlider<MarketModel>(
                  title: "Dostępne targi",
                  elementBuilder: (context, market) =>
                      MarketCard(market: market),
                  items: _markets,
                ),
                FlatButton(
                  child: Text("Sync"),
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });
                    Api.getAllEventsFromFb();

                    _fetchMarkets();
                  },
                )
              ],
            ),
    );
  }
}
