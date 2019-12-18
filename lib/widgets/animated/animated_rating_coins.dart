import 'package:flutter/material.dart';

import '../raiting_coins.dart';

class AnimatedRatingCoins extends StatefulWidget {
  const AnimatedRatingCoins({
    Key key,
    @required this.raiting,
    this.delay,
    this.onTap,
    this.duration,
  }) : super(key: key);

  final double raiting;
  final Duration duration;
  final Duration delay;
  final VoidCallback onTap;

  @override
  _AnimatedRatingCoinsState createState() => _AnimatedRatingCoinsState();
}

class _AnimatedRatingCoinsState extends State<AnimatedRatingCoins>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      value: 0.0,
      lowerBound: 0,
      upperBound: 5.0,
    );
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    if (widget.raiting == null) return;

    if (widget.delay != null) await Future<void>.delayed(widget.delay);

    await _controller.animateTo(
      widget.raiting,
      duration: widget.duration ?? const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(AnimatedRatingCoins oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.raiting != widget.raiting) {
      _startAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, snapshot) {
            return RaitingCoins(
              size: 35,
              value: widget.raiting == null ? null : _controller.value,
            );
          }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
