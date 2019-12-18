import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:targowisko/models/owner_model.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/image_picker_util.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/animated/animated_rating_coins.dart';
import 'package:targowisko/widgets/avatar.dart';
import 'package:targowisko/widgets/buttons/rounded_button.dart';
import 'package:targowisko/widgets/buttons/secondary_button/secondary_button.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _setFbAvatarLoading = false;

  Future<void> _setFbAvatar() async {
    OwnerModel result;
    setState(() {
      _setFbAvatarLoading = true;
    });
    try {
      Alert.loader(context, "Pobieranie nowego awataru");
      result = await Api.setFbAvatar();
    } on ApiException catch (err) {
      Navigator.pop(context);
      await Alert.open(
        context,
        title: "Wystąpił nieoczekiwany bład",
        content: err.message,
      );
      return;
    } finally {
      Navigator.pop(context);
      setState(() {
        _setFbAvatarLoading = false;
        Api.currentUser.avatar = result.avatar;
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
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [StyleProvider.of(context).shadow.mainShadow],
              ),
              child: Avatar(
                imageUrl: Api.currentUser.avatar,
                size: 100,
                nickname: Api.currentUser.firstName,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            Api.currentUser.firstName + " " + Api.currentUser.lastName,
            textAlign: TextAlign.center,
            style: StyleProvider.of(context).font.pacifico.copyWith(
                  fontSize: 20,
                ),
          ),
          SizedBox(
            height: 10,
          ),
          SecondaryButton(
            onTap: _setFbAvatar,
            loading: _setFbAvatarLoading,
          ),
          SizedBox(
            height: 10,
          ),
          RoundedButton(
            title: "Dodaj własne zdjęcie",
            fontSize: 20,
            height: 50,
            onTap: () async {
              File image = await ImagePickerUtil.pickImage(
                context,
              );
              Alert.loader(context, "Wysyłanie nowego avataru");
              OwnerModel user;
              try {
                user = await Api.setAvatar(image);
              } on Exception catch (err) {
                Navigator.pop(context);
                Alert.open(
                  context,
                  title: "Błąd podczas ustawiania avataru",
                  confirmLabel: "Zrozumiano",
                );
                return;
              }
              Navigator.pop(context);
              Alert.open(
                context,
                title: "Zdjęcie zostało pomyślnie ustawione",
              );

              Api.currentUser.avatar = user.avatar;
              setState(() {});
            },
          ),
          SizedBox(
            height: 20,
          ),
          Text("Twoja liczba produktów:"),
          Text(
            Api.currentUser.productsCount.toString(),
            textAlign: TextAlign.left,
            style: StyleProvider.of(context).font.pacifico.copyWith(
                  fontSize: 20,
                ),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Twoja ocena:"),
          SizedBox(
            height: 10,
          ),
          AnimatedRatingCoins(
            raiting: Api.currentUser.averageRating,
            delay: const Duration(milliseconds: 300),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Z nami od:"),
          Text(
            DateFormat.yMd().format(
              Api.currentUser.createdAt ??
                  DateTime.now().subtract(Duration(days: 3)),
            ),
            textAlign: TextAlign.left,
            style: StyleProvider.of(context).font.pacifico.copyWith(
                  fontSize: 20,
                ),
          ),
        ],
      ),
    );
  }
}
