import 'package:flutter/material.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/buttons/primary_button/primary_button.dart';
import 'package:targowisko/widgets/input/input.dart';
import 'package:targowisko/widgets/list_scaffold.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool _loading = false;
  final TextEditingController _description = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _price = TextEditingController();

  void _addProduct() async {
    try {
      setState(() {
        _loading = true;
      });
      double price;
      price = double.parse(_price.text);

      final result = await Api.product.create(
        description: _description.text,
        name: _name.text,
        category: 1,
        picture: null,
        price: (price * 100).toInt(),
      );
    } on FormatException catch (err) {
      await Alert.open(
        context,
        title: "Podaj poprawną kwotę",
        content: "Podano: ${_price.text}",
      );
    } on ApiException catch (err) {
      await Alert.open(
        context,
        title: "Wystąpił błąd zapytania",
        content: err.message,
      );
    } on Exception catch (err) {
      Alert.open(
        context,
        title: "Wystąpił nieoczekiwany błąd",
        content: err.toString(),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_loading,
      child: ListScaffold(
        title: "Dodaj Produkt",
        child: ListView(
          padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
          children: <Widget>[
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [StyleProvider.of(context).shadow.mainShadow],
                  gradient: StyleProvider.of(context).gradient.cardGradient3,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.add_photo_alternate,
                        color: StyleProvider.of(context).colors.primaryContent,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Input(
              controller: _name,
              title: "Nazwa produktu",
              withBorder: true,
            ),
            const SizedBox(height: 10),
            Input(
              title: "Opis",
              controller: _description,
              lines: 5,
              withBorder: true,
            ),
            const SizedBox(height: 10),
            Input(
              title: "Cena",
              controller: _price,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
                signed: false,
              ),
              withBorder: true,
            ),
            const SizedBox(height: 25),
            PrimaryButton(
              label: "Dodaj produkt",
              loading: _loading,
              onPressed: _loading ? null : _addProduct,
            ),
          ],
        ),
      ),
    );
  }
}
