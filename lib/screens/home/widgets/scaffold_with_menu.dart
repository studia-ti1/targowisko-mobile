import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

import 'app_menu.dart';

typedef BuilderFunction = Widget Function({
  @required VoidCallback closeMenu,
  @required VoidCallback openMenu,
});

class ScaffoldWithMenu extends StatefulWidget {
  final BuilderFunction builder;

  ScaffoldWithMenu({@required this.builder}) : assert(builder != null);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ScaffoldWithMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool _isMenuOpened = false;

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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeMenu() {
    setState(() {
      _animationController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      _isMenuOpened = false;
    });
  }

  void _openMenu() {
    setState(() {
      _animationController.animateTo(1,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      _isMenuOpened = true;
    });
  }

  void _handleOpenMenu() {
    if (_isMenuOpened)
      _closeMenu();
    else
      _openMenu();
  }

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
                            child: widget.builder(
                          closeMenu: _closeMenu,
                          openMenu: _openMenu,
                        )),
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
