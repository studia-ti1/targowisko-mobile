import 'package:flutter/material.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/buttons/secondary_button/secondary_button.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _setFbAvatarLoading = false;

  Future<void> _setFbAvatar() async {
    setState(() {
      _setFbAvatarLoading = true;
    });
    try {
      await Api.setFbAvatar();
    } on ApiException catch (err) {
      await Alert.open(
        context,
        title: "Wystąpił nieoczekiwany bład",
        content: err.message,
      );
      return;
    } finally {
      setState(() {
        _setFbAvatarLoading = false;
      });
    }
    await Alert.open(
      context,
      title: "Sukces",
      content: "Zdjęcie zostało pomyślnie zaktualizowane",
      confirmLabel: "Zrozumiano!",
      withStackTrace: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExtentListScaffold(
      title: "O mnie",
      navChild: Image.asset(
        StyleProvider.of(context).asset.user,
        width: 100,
        height: 100,
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
        children: <Widget>[
          SecondaryButton(
            onTap: _setFbAvatar,
            loading: _setFbAvatarLoading,
          ),
        ],
      ),
    );
  }
}
