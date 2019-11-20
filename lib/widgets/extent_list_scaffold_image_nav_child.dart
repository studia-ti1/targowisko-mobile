import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ExtentListScaffoldImageNavChild extends StatelessWidget {
  const ExtentListScaffoldImageNavChild({
    Key key,
    @required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Transform.scale(
        scale: 1.2,
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              imageUrl: imageUrl,
            ),
            Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                color: Colors.black38,
              ),
            )
          ],
        ),
      ),
    );
  }
}
