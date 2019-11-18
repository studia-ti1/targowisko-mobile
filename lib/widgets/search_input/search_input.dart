import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class SearchInput extends SliverPersistentHeaderDelegate {
  SearchInput({
    @required this.topPadding,
  });

  final double topPadding;

  @override
  double get minExtent => 70 + topPadding;
  @override
  double get maxExtent => 70 + topPadding;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(
                0,
                0,
                0,
                Tween(begin: 0.0, end: 0.35)
                    .transform(shrinkOffset.clamp(0.0, 30.0) / 30.0),
              ),
              offset: const Offset(1, 1),
              blurRadius: 5,
            )
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        margin: const EdgeInsets.fromLTRB(15, 25, 15, 25),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: StyleProvider.of(context).colors.searchBackground,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(SearchInput oldDelegate) {
    return false;
  }
}
