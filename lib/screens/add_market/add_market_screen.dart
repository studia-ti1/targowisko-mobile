import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/screens/home/widgets/market_card.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/widgets/list_scaffold.dart';

class AddMarketScreen extends StatefulWidget {
  @override
  _AddMarketScreenState createState() => _AddMarketScreenState();
}

class _AddMarketScreenState extends State<AddMarketScreen> {
  List<MarketModel> _markets = [];

  @override
  void initState() {
    _fetchMarkets();
    super.initState();
  }

  Future<void> _fetchMarkets() async {
    List<MarketModel> markets;

    try {
      markets = await Api.getAllEventsFromFb();
    } on ApiException catch (err) {
      Alert.open(context, title: "Wystąpił błąd", content: err.message);
      return;
    }
    setState(() {
      _markets = markets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListScaffold(
      title: "Dodaj market",
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final market = _markets[index];
          return MarketCard(
            market: market,
          );
        },
        itemCount: _markets.length,
      ),
    );
  }
}
