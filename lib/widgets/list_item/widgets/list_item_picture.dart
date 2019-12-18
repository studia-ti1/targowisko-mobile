import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class ListItemPicture extends StatelessWidget {
  final String imageUrl;

  ListItemPicture({
    @required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) => imageUrl != null
      ? CachedNetworkImage(
          fit: BoxFit.cover,
          width: 110,
          height: 110,
          imageUrl: imageUrl,
        )
      : Container(
          alignment: Alignment.center,
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: StyleProvider.of(context).colors.primaryAccent,
          ),
          child: Image.asset(
            StyleProvider.of(context).asset.appLogo,
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
        );
}
