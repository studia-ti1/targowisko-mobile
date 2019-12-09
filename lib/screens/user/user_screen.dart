import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExtentListScaffold(
      title: "O mnie",
      navChild: Image.asset(
        StyleProvider.of(context).asset.user,
        width: 100,
        height: 100,
      ),
    );
  }
}
