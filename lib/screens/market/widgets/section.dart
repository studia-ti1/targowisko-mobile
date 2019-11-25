import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/buttons/rounded_button.dart';

class Section extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets titlePadding;
  final VoidCallback onMorePress;

  Section({
    @required this.title,
    @required this.child,
    this.titlePadding,
    this.onMorePress,
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: titlePadding ?? const EdgeInsets.only(bottom: 15),
          height: 0.5,
          decoration: BoxDecoration(
            color: StyleProvider.of(context).colors.content.withOpacity(0.5),
          ),
        ),
        Padding(
          padding: titlePadding ?? const EdgeInsets.only(bottom: 15),
          child: Row(
            children: <Widget>[
              Text(
                title,
                style: StyleProvider.of(context)
                    .font
                    .pacifico
                    .copyWith(fontSize: 16),
              ),
              Spacer(),
              if (onMorePress != null)
                RoundedButton(
                  onTap: onMorePress,
                  title: "Więcej...",
                ),
            ],
          ),
        ),
        child,
      ],
    );
  }
}
