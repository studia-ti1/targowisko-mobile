import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/input/input.dart';

class SearchInput extends SliverPersistentHeaderDelegate {
  SearchInput({
    @required this.topPadding,
    @required this.onSearch,
    @required this.controller,
  });

  final double topPadding;
  final TextEditingController controller;
  final ValueGetter<Future<void>> onSearch;

  @override
  double get minExtent => 70;
  @override
  double get maxExtent => 100;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: Center(
        child: Container(
          height: minExtent,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: StyleProvider.of(context).colors.primaryBackground,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(
                  0,
                  0,
                  0,
                  Tween(begin: 0.0, end: 0.15)
                      .transform(shrinkOffset.clamp(0.0, 30.0) / 30.0),
                ),
                offset: const Offset(1, 1),
                blurRadius: 5,
              )
            ],
          ),
          child: _SearchInput(controller: controller, onSearch: onSearch),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(SearchInput oldDelegate) {
    return false;
  }
}

class _SearchInput extends StatefulWidget {
  const _SearchInput({
    Key key,
    @required this.controller,
    @required this.onSearch,
  }) : super(key: key);

  final TextEditingController controller;
  final ValueGetter<Future<void>> onSearch;

  @override
  __SearchInputState createState() => __SearchInputState();
}

class __SearchInputState extends State<_SearchInput> {
  bool _enabled = true;
  bool _searched = false;

  void _search() async {
    if (_searched && _enabled) {
      setState(() {
        _searched = false;
        _enabled = false;
      });
      widget.controller.clear();
      await widget.onSearch();
      setState(() {
        _enabled = true;
      });
    } else {
      if (!_enabled) return;
      setState(() {
        _enabled = false;
      });
      await widget.onSearch();
      setState(() {
        _enabled = true;
        _searched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: StyleProvider.of(context).colors.searchBackground,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Input(
                enabled: _enabled && !_searched,
                controller: widget.controller,
                placeholder: "Wyszukaj...",
              ),
            ),
            Container(
              width: 50,
              padding: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Material(
                  color: _enabled
                      ? _searched
                          ? Colors.red
                          : StyleProvider.of(context).colors.primaryAccent
                      : Colors.grey,
                  child: IconButton(
                    splashColor: Colors.white54,
                    icon: Icon(_searched ? Icons.cancel : Icons.search,
                        color: StyleProvider.of(context).colors.primaryContent),
                    onPressed: _enabled ? _search : null,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
