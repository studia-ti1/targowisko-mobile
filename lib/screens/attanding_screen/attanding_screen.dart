import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/screens/home/home_screen.dart';
import 'package:targowisko/screens/market/market_screen.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/widgets/list_item/list_item.dart';
import 'package:targowisko/widgets/list_item/widgets/list_item_picture.dart';
import 'package:targowisko/widgets/list_scaffold.dart';

import '../../routes.dart';

class AttendingScreen extends StatefulWidget {
  AttendingScreen();

  @override
  AttendingScreenState createState() => AttendingScreenState();
}

class AttendingScreenState extends State<AttendingScreen> {
  List<MarketModel> _markets = [];
  bool _loading = true;

  Future<void> _openMarket(MarketModel market) async {
    await Navigator.pushNamed(
      context,
      Routes.market,
      arguments: MarketScreenArgs(market: market),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchMarkets();
  }

  Future<void> _fetchMarkets() async {
    try {
      setState(() {
        _loading = true;
      });
      _markets = await Api.market.fetchAttending();

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
                  itemCount: _markets.length,
                  itemBuilder: (BuildContext context, int index) {
                    final market = _markets[index];
                    return ListItem(
                      description: market.description,
                      title: market.name,
                      averageRating: market.averageRating,
                      onTap: () => _openMarket(market),
                      child: ListItemPicture(
                        imageUrl: market.imageUrl,
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
