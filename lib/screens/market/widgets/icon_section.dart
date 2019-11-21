import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class IconSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  IconSection({
    @required this.icon,
    @required this.title,
    @required this.content,
  }) : assert(content != null && title != null && icon != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 24,
            color: StyleProvider.of(context).colors.secondaryContent,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: StyleProvider.of(context)
                    .font
                    .normal
                    .copyWith(fontSize: 13),
              ),
              SizedBox(height: 5),
              Text(
                content,
                style: StyleProvider.of(context).font.normal.copyWith(
                      fontSize: 13,
                      color: StyleProvider.of(context).colors.secondaryContent,
                    ),
              )
            ],
          )
        ],
      ),
    );
  }
}
