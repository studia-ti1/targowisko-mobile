import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  RoundedButton({
    @required this.title,
    @required this.onTap,
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Material(
        color: StyleProvider.of(context).colors.primaryAccent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 25,
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