import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/raiting_coins.dart';

class ListItem extends StatefulWidget {
  final String title;
  final String description;
  final double averageRating;
  final Widget child;
  final VoidCallback onTap;

  ListItem({
    @required this.child,
    @required this.title,
    this.description,
    this.averageRating,
    this.onTap,
  }) : assert(title != null);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, value: 0.0, lowerBound: 0.0, upperBound: 1.0);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(1.0, duration: const Duration(milliseconds: 300));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                child: Container(
                  height: 110,
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color:
                                StyleProvider.of(context).colors.primaryAccent,
                          ),
                          child: widget.child,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: StyleProvider.of(context)
                                  .font
                                  .pacifico
                                  .copyWith(fontSize: 20),
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Text(
                                widget.description ?? "---",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: StyleProvider.of(context)
                                    .font
                                    .normal
                                    .copyWith(fontSize: 12, height: 1.3),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              height: 20,
                              width: 200,
                              child: RaitingCoins(
                                value: widget.averageRating,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _controller
                .drive(Tween(begin: 0.5, end: 1.0))
                .drive(CurveTween(curve: Curves.easeOut))
                .value,
            child: Opacity(
              opacity: _controller.value,
              child: child,
            ),
          );
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
