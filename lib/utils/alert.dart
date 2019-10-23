import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class Alert {
  Alert._();
  static Future<void> open(
    BuildContext context, {
    @required String title,
    String content,
    VoidCallback onConfirm,
    VoidCallback onCancel,
  }) {
    assert(title != null);
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              title,
              style: StyleProvider.of(context).font.bold.copyWith(fontSize: 16),
            ),
            content: content != null
                ? Text(
                    title,
                    style: StyleProvider.of(context)
                        .font
                        .normal
                        .copyWith(fontSize: 13),
                  )
                : null,
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "AKCEPTUJ",
                  style: StyleProvider.of(context)
                      .font
                      .bold
                      .copyWith(fontSize: 13),
                ),
                onPressed: onConfirm ?? () => Navigator.pop(context),
              ),
              if (onCancel != null)
                FlatButton(
                  child: Text(
                    "ANULUJ",
                    style: StyleProvider.of(context)
                        .font
                        .bold
                        .copyWith(fontSize: 13),
                  ),
                  onPressed: onCancel,
                ),
            ],
          );
        });
  }
}
