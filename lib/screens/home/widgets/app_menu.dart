import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:targowisko/routes.dart';
import 'package:targowisko/utils/style_provider.dart';

class AppMenu extends StatelessWidget {
  final VoidCallback closeMenu;

  AppMenu({@required this.closeMenu}) : assert(closeMenu != null);

  Future<void> _logout(BuildContext context) async {
    await FacebookLogin().logOut();
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              _AppBarMenuHeader(),
              _AppMenuElement(
                title: "Produkty",
                icon: Icons.shopping_basket,
                onTap: () {
                  Navigator.pushNamed(context, Routes.products);
                  closeMenu();
                },
              ),
              _AppMenuElement(
                title: "Targi",
                icon: Icons.store,
                onTap: () {
                  Navigator.pushNamed(context, Routes.markets);
                  closeMenu();
                },
              ),
              _AppMenuElement(
                title: "Wystawcy",
                icon: Icons.people,
                onTap: () {
                  Navigator.pushNamed(context, Routes.sellers);
                  closeMenu();
                },
              ),
              _AppMenuElement(
                title: "Ja",
                icon: Icons.person,
                onTap: () {
                  closeMenu();
                },
              ),
            ],
          ),
        ),
        _AppMenuElement(
          title: "Wyloguj",
          icon: Icons.vpn_key,
          onTap: () => _logout(context),
        ),
      ],
    );
  }
}

class _AppBarMenuHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        children: <Widget>[
          Image.asset(
            StyleProvider.of(context).asset.appLogo,
            width: 40,
            height: 40,
          ),
          SizedBox(width: 10),
          Expanded(
            child: AutoSizeText(
              "Targowisko",
              maxLines: 1,
              maxFontSize: 20,
              minFontSize: 13,
              overflow: TextOverflow.ellipsis,
              style: StyleProvider.of(context)
                  .font
                  .pacificoPrimary
                  .copyWith(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}

class _AppMenuElement extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _AppMenuElement({
    @required this.title,
    @required this.icon,
    @required this.onTap,
  }) : assert(title != null && icon != null);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: StyleProvider.of(context).colors.primaryContent,
      ),
      title: Text(
        title,
        style:
            StyleProvider.of(context).font.primaryNormal.copyWith(fontSize: 16),
      ),
    );
  }
}
