import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static Future<File> pickImage(
    BuildContext context, {
    int imageQuality = 70,
    double maxHeight = 1280,
    double maxWidth = 1280,
  }) async =>
      showModalBottomSheet<File>(
        context: context,
        builder: (BuildContext context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add_a_photo),
              title: Text("Aparat"),
              onTap: () async {
                Navigator.pop(
                  context,
                  await ImagePicker.pickImage(
                    imageQuality: imageQuality,
                    maxHeight: maxHeight,
                    maxWidth: maxWidth,
                    source: ImageSource.camera,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add_photo_alternate),
              title: Text("Galeria"),
              onTap: () async {
                Navigator.pop(
                  context,
                  await ImagePicker.pickImage(
                    imageQuality: imageQuality,
                    maxHeight: maxHeight,
                    maxWidth: maxWidth,
                    source: ImageSource.gallery,
                  ),
                );
              },
            ),
          ],
        ),
      );
}
