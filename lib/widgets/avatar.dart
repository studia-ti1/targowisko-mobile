import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class Avatar extends StatelessWidget {
  final String imageUrl;
  final String nickname;
  final double size;

  Avatar({
    @required this.imageUrl,
    @required this.size,
    this.nickname,
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
                ? Center(
                    child: Text(
                      nickname != null ? nickname[0] : "",
                      style: StyleProvider.of(context)
                          .font
                          .pacificoPrimary
                          .copyWith(fontSize: size * 0.5),
                    ),
                  )
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
