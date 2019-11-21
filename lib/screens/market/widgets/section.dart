import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class Section extends StatelessWidget {
  final String title;
  final Widget child;

  Section({
    @required this.title,
    @required this.child,
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: StyleProvider.of(context).font.pacifico.copyWith(fontSize: 16),
        ),
        SizedBox(height: 15),
        child,
      ],
    );
  }
}
