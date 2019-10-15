import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/buttons/primary_button/primary_button.dart';
import 'package:targowisko/widgets/input/input.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _loading = false;
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, lowerBound: 0, upperBound: 1)
          ..value = 1;

    Timer(Duration(seconds: 3), () {
      _animationController.animateTo(
        0,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _handleLogin() async {
    setState(() {
      _loading = true;
    });
    final result = await post(
      'https://targowisko-api.herokuapp.com/api/v1/users/login',
      body: <String, dynamic>{
        "user[email]": _loginController.text,
        "user[password]": _passwordController.text,
      },
    );
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(result.body),
        ));
      },
    );
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 0, bottom: 15),
        children: <Widget>[
          Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 450),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Input(
                          enabled: !_loading,
                          placeholder: "Nazwa użytkownika",
                          controller: _loginController,
                        ),
                        SizedBox(height: 15),
                        Input(
                          enabled: !_loading,
                          controller: _passwordController,
                          placeholder: "Hasło",
                          obscureText: true,
                        ),
                        SizedBox(height: 15),
                        PrimaryButton(
                          loading: _loading,
                          onPressed: _handleLogin,
                          label: "Zaloguj",
                        ),
                      ],
                    ),
                  )
                ],
              ),
              AnimatedBuilder(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/logo.png'),
                    SizedBox(height: 20),
                    Text(
                      "Targowisko",
                      style: StyleProvider.of(context)
                          .font
                          .pacificoWhite
                          .copyWith(fontSize: 30),
                    )
                  ],
                ),
                animation: _animationController,
                builder: (context, child) {
                  double radius = 30 * (1 - _animationController.value);
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [StyleProvider.of(context).shadow.mainShadow],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(radius),
                        bottomRight: Radius.circular(radius),
                      ),
                      child: Container(
                        height: (MediaQuery.of(context).size.height *
                                _animationController.value) +
                            (420 * (1 - _animationController.value)),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: StyleProvider.of(context).gradient.primary,
                        ),
                        child: child,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
