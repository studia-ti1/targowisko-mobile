import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class Avatar extends StatelessWidget {
  final String imageUrl;
  final double size;

  Avatar({
    @required this.imageUrl,
    @required this.size,
  }) : assert(size != null);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: StyleProvider.of(context).colors.primaryAccent,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: imageUrl == null
                ? null
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: size,
                    width: size,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
