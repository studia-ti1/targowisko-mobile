import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final double height;
  final VoidCallback onTap;
  final BorderRadius borderRadius;
  final Alignment contentAlignment;

  RoundedButton({
    @required this.title,
    @required this.onTap,
    this.height,
    this.borderRadius,
    this.contentAlignment,
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(5)),
      child: Material(
        color: StyleProvider.of(context).colors.primaryAccent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: contentAlignment ?? Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: height ?? 25,
            child: Text(
              title,
              style: StyleProvider.of(context).font.pacificoPrimary.copyWith(
                    fontSize: 12,
                    color: StyleProvider.of(context).colors.primaryContent,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
