import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:targowisko/models/market_model.dart';
import 'package:targowisko/screens/home/widgets/market_card.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/sliders/element_slider.dart';

import 'widgets/app_menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<MarketModel> markets = [];
  AnimationController _animationController;
  bool _isMenuOpened = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchMarkets();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchMarkets() async {
    setState(() {
      _loading = true;
    });
    final result = await http.get(
      'https://targowisko.herokuapp.com/api/v1/markets/index',
      headers: {
        'access-token': Api.accesToken,
      },
    );
    setState(() {
      _loading = false;
    });
    if (result.statusCode >= 300) {
      Alert.open(context, title: "Wystąpił błąd", content: result.body);

      return;
    }

    final List jsonEventList = jsonDecode(result.body);
    setState(() {
      markets = jsonEventList
          .map((dynamic market) => MarketModel.fromJson(market))
          .toList();
    });
  }

  void _closeMenu() {
    _animationController.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _openMenu() {
    _animationController.animateTo(1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _handleOpenMenu() => setState(() {
        if (_isMenuOpened)
          _closeMenu();
        else
          _openMenu();
        _isMenuOpened = !_isMenuOpened;
      });

  @override
  Widget build(BuildContext context) {
    final halfWidth = MediaQuery.of(context).size.width / 2;
    return Material(
      child: Scaffold(
        backgroundColor: StyleProvider.of(context).colors.primaryAccent,
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: halfWidth,
              child: SafeArea(
                child: AppMenu(),
              ),
            ),
            AnimatedBuilder(
                animation: _animationController,
                child: GestureDetector(
                  onTapDown: (_) {
                    if (_isMenuOpened) _closeMenu();
                  },
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            _isMenuOpened ? Icons.close : Icons.menu,
                            color: StyleProvider.of(context).colors.content,
                          ),
                          onPressed: _handleOpenMenu,
                        ),
                        Expanded(
                          // TODO: improve loading
                          child: _loading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        StyleProvider.of(context)
                                            .colors
                                            .primaryAccent),
                                  ),
                                )
                              : ListView(
                                  children: <Widget>[
                                    ElementSlider<MarketModel>(
                                      title: "Dostępne targi",
                                      elementBuilder: (context, market) =>
                                          MarketCard(market: market),
                                      items: markets,
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                builder: (context, widget) {
                  final radius = _animationController.value * 30;
                  return Transform.translate(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          StyleProvider.of(context).shadow.mainShadow
                        ],
                        color:
                            StyleProvider.of(context).colors.primaryBackground,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(radius),
                          bottomLeft: Radius.circular(radius),
                        ),
                      ),
                      child: widget,
                    ),
                    offset: Offset(halfWidth * _animationController.value, 0),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
