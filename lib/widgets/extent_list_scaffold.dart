import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:targowisko/utils/style_provider.dart';

import 'nav_bar.dart';

class ExtentListScaffold extends StatefulWidget {
  final Widget child;
  final String title;
  final Widget navChild;
  final VoidCallback onLikePress;
  final bool liked;

  ExtentListScaffold({
    @required this.title,
    this.child,
    this.navChild,
    this.onLikePress,
    this.liked = false,
  }) : assert(title != null && child != null);

  @override
  _ExtentListScaffoldState createState() => _ExtentListScaffoldState();
}

class _ExtentListScaffoldState extends State<ExtentListScaffold>
    with SingleTickerProviderStateMixin {
  double _getTopPadding(BuildContext context) =>
      MediaQuery.of(context).padding?.top ?? 0;

  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = _getTopPadding(context);
    return Scaffold(
      backgroundColor: StyleProvider.of(context).colors.primaryBackground,
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 400,
            decoration: BoxDecoration(
              gradient: StyleProvider.of(context).gradient.cardGradient2,
            ),
            child: AnimatedBuilder(
                animation: _controller,
                child: Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: topPadding + 50),
                  child: widget.navChild,
                ),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _controller
                        .drive(Tween(begin: 0.8, end: 1.0))
                        .drive(CurveTween(curve: Curves.easeOut))
                        .value,
                    child: Opacity(
                      opacity: _controller.value,
                      child: child,
                    ),
                  );
                }),
          ),
          NestedScrollView(
            body: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 70 + topPadding),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [StyleProvider.of(context).shadow.lightShadow],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color:
                            StyleProvider.of(context).colors.primaryBackground,
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
                if (widget.onLikePress != null)
                  Transform.translate(
                    offset: Offset(0, 65),
                    child: Container(
                      margin: const EdgeInsets.only(right: 40),
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          boxShadow: [
                            StyleProvider.of(context).shadow.mainShadow
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Material(
                            color: StyleProvider.of(context)
                                .colors
                                .primaryBackground,
                            child: InkWell(
                              child: widget.liked
                                  ? Icon(
                                      Icons.favorite,
                                      color: StyleProvider.of(context)
                                          .colors
                                          .primaryAccent,
                                    )
                                  : const Icon(Icons.favorite_border),
                              onTap: widget.onLikePress,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    controller: _controller,
                    topPadding: topPadding,
                    title: widget.title,
                  ),
                )
              ];
            },
          )
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.topPadding,
    @required this.title,
    @required this.controller,
  });

  final AnimationController controller;
  final String title;
  final double topPadding;

  @override
  double get minExtent => 70 + topPadding;
  @override
  double get maxExtent => 130 + topPadding;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.value = shrinkOffset > 0 ? 1 - (shrinkOffset / maxExtent) : 1;
    });
    return Container(
      alignment: Alignment.topCenter,
      constraints: BoxConstraints.expand(),
      child: NavBar(
        title: title,
        shrinkOffset: shrinkOffset,
        maxExtent: maxExtent,
        minExtent: minExtent,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}