import 'package:flutter/material.dart';
import 'package:targowisko/widgets/buttons/rounded_button.dart';
import 'package:targowisko/widgets/input/input.dart';

import '../raiting_coins.dart';

class RateCoins extends StatefulWidget {
  final ValueChanged<int> onRate;
  const RateCoins({
    @required this.onRate,
    Key key,
  }) : super(key: key);

  @override
  _RateCoinsState createState() => _RateCoinsState();
}

class _RateCoinsState extends State<RateCoins>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool _enabled = false;
  bool _isRated = false;
  int _rate = 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 0.0,
      lowerBound: 0,
      upperBound: 5.0,
    );
    _startAnimation();
  }

  void _startAnimation() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    await _controller.animateTo(
      5.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    await _controller.animateTo(
      2.7,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    await _controller.animateTo(
      4.2,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    await _controller.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    setState(() {
      _enabled = true;
    });
  }

  void _setRate(int number) {
    setState(() {
      _isRated = true;
      _rate = number;
    });
    _controller.animateTo(
      number.toDouble(),
      duration: const Duration(milliseconds: 900),
      curve: Curves.elasticOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedBuilder(
          animation: _controller,
          builder: (context, snapshot) {
            return RaitingCoins(
              onCoinPress: _enabled ? _setRate : null,
              mainAxisAlignment: MainAxisAlignment.center,
              withText: false,
              size: (MediaQuery.of(context).size.width * 0.65) * 0.2,
              value: _controller.value,
            );
          },
        ),
        if (_isRated)
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              width: 200,
              height: 40,
              child: RoundedButton(
                fontSize: 20,
                title: "Zatwierdź",
                onTap: () => widget.onRate(_rate),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CommentElem extends StatefulWidget {
  final ValueChanged<String> onComment;

  CommentElem({@required this.onComment});

  @override
  _CommentElemState createState() => _CommentElemState();
}

class _CommentElemState extends State<CommentElem> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Input(
            enabled: true,
            lines: 4,
            placeholder: "Twój komentarz...",
            withBorder: true,
            controller: _controller,
          ),
          if (_controller.text.isNotEmpty)
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                width: 200,
                height: 40,
                child: RoundedButton(
                  fontSize: 20,
                  title: "Wystaw ocenę",
                  onTap: () => widget.onComment(_controller.text),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
