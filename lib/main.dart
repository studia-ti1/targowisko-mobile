import 'package:flutter/material.dart';
import 'package:targowisko/routes.dart';
import 'package:targowisko/utils/style_provider.dart';

const _appName = "Targowisko";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StyleProvider(
      colors: AppColors(
        primaryAccent: const Color(0xFFDE6589),
        primaryContent: Colors.white,
        secondaryAccent: const Color(0xFF69C0D3),
        secondaryContent: Color(0xFFCCCCCC),
        content: Colors.black,
        primaryBackground: Colors.white,
        secondaryBackground: const Color(0xFF222222),
      ),
      child: MaterialApp(
        title: _appName,
        onGenerateRoute: Routes.onGenerateRoute,
      ),
    );
  }
}
