import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class Section extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets titlePadding;

  Section({
    @required this.title,
    this.titlePadding,
    @required this.child,
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: titlePadding ?? const EdgeInsets.only(bottom: 15),
          child: Text(
            title,
            style:
                StyleProvider.of(context).font.pacifico.copyWith(fontSize: 16),
          ),
        ),
        child,
      ],
    );
  }
}
