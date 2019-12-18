import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/svg.dart';
import 'package:targowisko/routes.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/buttons/primary_button/primary_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    FacebookLogin().currentAccessToken.then((facebookToken) {
      if (facebookToken != null &&
          facebookToken.expires.isAfter(DateTime.now())) {
        _handleLogged(facebookToken.token);
      }
    });

    _controller = AnimationController(vsync: this, lowerBound: 0, upperBound: 1)
      ..value = 0
      ..repeat(min: 0, max: 1, period: Duration(seconds: 4), reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _loading = false;

  void set _isLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }

  Future<void> _handleLogin() async {
    final facebookLogin = FacebookLogin();
    final token = (await facebookLogin.currentAccessToken)?.token;

    if (token != null) return _handleLogged(token);

    _isLoading = true;
    final result = await facebookLogin.logIn(['email', 'user_events']);
    _isLoading = false;
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _handleLogged(result.accessToken.token);

        break;

      case FacebookLoginStatus.error:
        _handleLoginError(result);

        break;
      case FacebookLoginStatus.cancelledByUser:
        print("canceled");
        break;
      default:
        break;
    }
  }

  Future<void> _handleLoginError(FacebookLoginResult result) =>
      Alert.open(context, title: "Wystąpił błąd", content: result.errorMessage);

  Future<void> _handleLogged(String token) async {
    // sets access token
    Api.accesToken = token;

    Navigator.pushReplacementNamed(context, Routes.home);
  }

  Offset get _animationOffset {
    final tweenValue =
        _controller.drive(CurveTween(curve: Curves.easeInOut)).value * 20;

    return Offset(0, tweenValue - tweenValue / 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: StyleProvider.of(context).gradient.cardGradient3,
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: 40,
                      top: (MediaQuery.of(context).padding?.top ?? 0) + 40),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: AnimatedBuilder(
                    animation: _controller,
                    child: Image.asset('assets/logo.png'),
                    builder: (context, widget) => Transform.translate(
                      child: widget,
                      offset: _animationOffset,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [StyleProvider.of(context).shadow.mainShadow],
                  color: StyleProvider.of(context).colors.primaryBackground,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Targowisko",
                        style: StyleProvider.of(context)
                            .font
                            .pacifico
                            .copyWith(fontSize: 30),
                      ),
                      SizedBox(height: 20),
                      PrimaryButton(
                        loading: _loading,
                        onPressed: _handleLogin,
                        color: StyleProvider.of(context).colors.facebook,
                        icon: Container(
                          padding: const EdgeInsets.only(left: 5),
                          alignment: Alignment.centerLeft,
                          child: SvgPicture.asset(
                            StyleProvider.of(context).asset.facebookLogo,
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                            semanticsLabel: "Facebook logo",
                          ),
                        ),
                        label: "Zaloguj",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
