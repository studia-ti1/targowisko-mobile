import 'dart:io';

import 'package:flutter/material.dart';
import 'package:targowisko/models/product_model.dart';
import 'package:targowisko/utils/alert.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/image_picker_util.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/buttons/primary_button/primary_button.dart';
import 'package:targowisko/widgets/input/input.dart';
import 'package:targowisko/widgets/list_scaffold.dart';
import 'package:targowisko/widgets/select_category_section/select_category_section.dart';

import '../../routes.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool _loading = false;
  final TextEditingController _description = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _price = TextEditingController();
  File _image;
  bool _hasImage = false;
  ProductCategory _selectedCategory;

  void _addProduct() async {
    if (_selectedCategory == null) {
      Alert.open(context, title: "Brak danych", content: "Wybierz kategorię");
      return;
    }
    try {
      setState(() {
        _loading = true;
      });
      double price;
      price = double.parse(_price.text);

      final result = await Api.product.create(
        description: _description.text,
        name: _name.text,
        category: _selectedCategory,
        picture: _hasImage ? _image : null,
        price: (price * 100).toInt(),
      );

      _loading = false;

      // TODO: Products storage?

      Navigator.pushNamedAndRemoveUntil(
          context, Routes.home, ModalRoute.withName(Routes.home));
    } on FormatException catch (err) {
      Alert.open(
        context,
        title: "Podaj poprawną kwotę",
        content: "Podano: ${_price.text}",
      );
    } on ApiException catch (err) {
      Alert.open(
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
      if (!_loading) return;
      setState(() {
        _loading = false;
      });
    }
  }

  void _pickOrRemoveImage() async {
    if (_hasImage) {
      setState(() {
        _hasImage = false;
      });
      return;
    }

    File image = await ImagePickerUtil.pickImage(
      context,
    );

    if (image == null) return;

    // await Future<void>.delayed(const Duration(milliseconds: 300));
    setState(() {
      _hasImage = true;
      _image = image;
    });
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
              child: PhotoAddContainerWidget(
                hasImage: _hasImage,
                image: _image,
                onTap: _pickOrRemoveImage,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Kategoria",
              style: StyleProvider.of(context)
                  .font
                  .pacifico
                  .copyWith(fontSize: 17),
            ),
            SizedBox(height: 5),
            SelectCateogryWidget(
              onChange: (ProductCategory category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              onRemove: () {
                setState(() {
                  _selectedCategory = null;
                });
              },
              selected: _selectedCategory,
            ),
            SizedBox(height: 25),
            Input(
              enabled: !_loading,
              controller: _name,
              title: "Nazwa produktu",
              withBorder: true,
            ),
            const SizedBox(height: 10),
            Input(
              enabled: !_loading,
              title: "Opis",
              controller: _description,
              lines: 5,
              withBorder: true,
            ),
            const SizedBox(height: 10),
            Input(
              title: "Cena",
              enabled: !_loading,
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

class PhotoAddContainerWidget extends StatelessWidget {
  const PhotoAddContainerWidget({
    Key key,
    @required bool hasImage,
    @required File image,
    @required VoidCallback onTap,
  })  : _hasImage = hasImage,
        _image = image,
        _onTap = onTap,
        super(key: key);

  final bool _hasImage;
  final File _image;
  final VoidCallback _onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [StyleProvider.of(context).shadow.mainShadow],
        gradient: StyleProvider.of(context).gradient.cardGradient3,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _hasImage
                    ? Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(_image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: AnimatedAlign(
                      curve: Curves.easeOut,
                      alignment:
                          _hasImage ? Alignment.topLeft : Alignment.center,
                      duration: const Duration(milliseconds: 300),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _hasImage
                            ? Icon(
                                Icons.delete_forever,
                                color: StyleProvider.of(context)
                                    .colors
                                    .primaryContent,
                                size: 40,
                              )
                            : Icon(
                                Icons.add_photo_alternate,
                                color: StyleProvider.of(context)
                                    .colors
                                    .primaryContent,
                                size: 40,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
