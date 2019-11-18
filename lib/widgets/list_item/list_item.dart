import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/raiting_coins.dart';

class ListItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 110,
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: StyleProvider.of(context).colors.primaryAccent,
                      ),
                      child: child,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
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
                            description ?? "---",
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
                              value: averageRating,
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
    );
  }
}
