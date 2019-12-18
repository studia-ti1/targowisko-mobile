import 'package:flutter/material.dart';
import 'package:targowisko/models/owner_model.dart';
import 'package:targowisko/screens/home/home_screen.dart';
import 'package:targowisko/screens/market/market_screen.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/extent_list_scaffold.dart';

class SellersScreen extends StatefulWidget {
  @override
  _SellersScreenState createState() => _SellersScreenState();
}

class _SellersScreenState extends State<SellersScreen> {
  List<OwnerModel> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      setState(() {
        _loading = true;
      });
      _users = await Api.fetchUsers();

      setState(() {
        _loading = false;
      });
    } on ApiException catch (err) {
      Alert.open(
        context,
        title: "Wystąpił nieoczekiwany błąd",
        content: err.message,
        onConfirm: Navigator.of(context).pop,
        confirmLabel: "Rozumiem",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExtentListScaffold(
      title: "Wystawcy",
      navChild: Image.asset(
        StyleProvider.of(context).asset.sellerIcon,
        width: 100,
        height: 100,
      ),
      child: _loading
          ? CustomLoader(
              loadingText: "Pytamy ludzi kto sprzedaje...",
            )
          : ListView.separated(
              itemCount: _users.length,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              itemBuilder: (BuildContext context, int index) {
                final seller = _users[index];
                return SizedBox(
                  height: 170,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            StyleProvider.of(context).shadow.mainShadow
                          ],
                          borderRadius: BorderRadius.circular(20),
                          gradient: index % 2 == 0
                              ? StyleProvider.of(context).gradient.cardGradient3
                              : StyleProvider.of(context)
                                  .gradient
                                  .cardGradient2,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        child: SellerCardContent(
                          avatarUrl: seller.avatar,
                          productsCount: seller.productsCount,
                          rating: seller.averageRating,
                          sellerName: "${seller.firstName} ${seller.lastName}",
                        ),
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          splashColor: Colors.white10,
                          // TODO:
                          onTap: () {},
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 20,
                );
              },
            ),
    );
  }
}
