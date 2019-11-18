import 'package:flutter/material.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';
import 'package:targowisko/widgets/market_list_item.dart';

class MarketsScreen extends StatefulWidget {
  @override
  _MarketsScreenState createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  List<MarketModel> _markets = [];

  @override
  void initState() {
    super.initState();
    _fetchMarkets();
  }

  Future<void> _fetchMarkets() async {
    try {
      final markets = await Api.market.fetch();
      setState(() {
        _markets = markets;
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
    return ExtentListScaffold(
      title: "Targi",
      navChild: Image.asset(
        StyleProvider.of(context).asset.marketIcon,
        width: 100,
        height: 100,
      ),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(15, 40, 15, 10),
        itemBuilder: (BuildContext context, int index) {
          final market = _markets[index];
          return MarketListItem(market: market);
        },
        itemCount: _markets.length,
      ),
    );
  }
}
