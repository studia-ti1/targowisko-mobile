import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class NavBar extends StatelessWidget {
  final String title;

  NavBar({
    @required this.title,
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin:
          EdgeInsets.only(top: (MediaQuery.of(context).padding?.top ?? 0) + 5),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Material(
              color: Colors.transparent,
              child: BackButton(
                color: StyleProvider.of(context).colors.primaryBackground,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: StyleProvider.of(context)
                  .font
                  .pacificoPrimary
                  .copyWith(fontSize: 25),
            ),
          )
        ],
      ),
    );
  }
}
