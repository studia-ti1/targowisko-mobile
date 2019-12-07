import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/buttons/primary_button/primary_button.dart';
import 'package:targowisko/widgets/list_scaffold.dart';

class MarketData {
  bool isGoing;
  final MarketModel market;
  MarketData(this.market) : isGoing = false;
}

class AddMarketScreen extends StatefulWidget {
  @override
  _AddMarketScreenState createState() => _AddMarketScreenState();
}

class _AddMarketScreenState extends State<AddMarketScreen> {
  List<MarketData> _markets = [];
  bool _loading = false;

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
      _markets = markets.map((market) => MarketData(market)).toList();
    });
  }

  void toggleIsGoing(int index) {
    if (_loading) return;
    setState(() {
      _markets[index].isGoing = !_markets[index].isGoing;
    });
  }

  Future<void> _addMarkets() async {
    if (_loading) return;
    setState(() {
      _loading = true;
    });
    final selectedMarketsData =
        _markets.where((marketData) => marketData.isGoing);
    if (selectedMarketsData.isEmpty) {
      await Alert.open(context, title: "Wybierz przynajmniej jeden market");
      setState(() {
        _loading = false;
      });
      return;
    }
    final selectedMarkets =
        selectedMarketsData.map((marketData) => marketData.market);
    final facebookEventIds =
        selectedMarkets.map((markets) => markets.id.toString()).toList();
    final success = await Api.market.create(facebookEventIds);
    print("Market success: ${success}");
    if (success) {
      Navigator.pop(context);
    } else {
      await Alert.open(context, title: "Wystąpił nieoczekiwany błąd");
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListScaffold(
      title: "Dodawanie marketów",
      child: Stack(
        children: <Widget>[
          ListView.separated(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 65),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0)
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                      "Wybierz wydarzenia na podstawie"
                      " których chcesz utworzyć market",
                      style: StyleProvider.of(context)
                          .font
                          .normal
                          .copyWith(fontSize: 16)),
                );
              final marketData = _markets[index - 1];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: FbEventCard(
                  market: marketData.market,
                  isGoing: marketData.isGoing,
                  onTap: () => toggleIsGoing(index - 1),
                ),
              );
            },
            itemCount: _markets.length + 1,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 1,
                // color: StyleProvider.of(context).colors.secondaryAccent,
              );
            },
          ),
          Container(
            padding: EdgeInsets.all(15),
            alignment: Alignment.bottomCenter,
            child: PrimaryButton(
              loading: _loading,
              label: "Stwórz markety",
              onPressed: _addMarkets,
            ),
          )
        ],
      ),
    );
  }
}

class FbEventCard extends StatelessWidget {
  final MarketModel market;
  final bool isGoing;
  final VoidCallback onTap;

  FbEventCard({
    @required this.market,
    @required this.isGoing,
    @required this.onTap,
  }) : assert(isGoing != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              market.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: StyleProvider.of(context)
                  .font
                  .pacifico
                  .copyWith(fontSize: 18),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 100,
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: StyleProvider.of(context)
                                .colors
                                .secondaryAccent,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: constraints.maxWidth * 0.2,
                            child: Icon(
                              Icons.done,
                              color: StyleProvider.of(context)
                                  .colors
                                  .primaryBackground,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:
                                StyleProvider.of(context).colors.primaryAccent,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: constraints.maxWidth * 0.2,
                            child: Icon(
                              Icons.cancel,
                              color: StyleProvider.of(context)
                                  .colors
                                  .primaryBackground
                                  .withOpacity(0.5),
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedAlign(
                    alignment:
                        isGoing ? Alignment.centerRight : Alignment.centerLeft,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Container(
                      height: 100,
                      width: constraints.maxWidth * 0.8,
                      decoration: BoxDecoration(
                        color: StyleProvider.of(context).colors.primaryContent,
                        boxShadow: [
                          StyleProvider.of(context).shadow.mainShadow
                        ],
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(market.imageUrl),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
