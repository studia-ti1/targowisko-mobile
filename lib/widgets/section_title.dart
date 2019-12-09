import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        title,
        style: StyleProvider.of(context).font.pacifico.copyWith(fontSize: 18),
      ),
    );
  }
}
