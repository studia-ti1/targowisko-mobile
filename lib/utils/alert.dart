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
    String confirmLabel = "akceptuj",
    String cancelLabel = "anuluj",
    bool withStackTrace = true,
  }) {
    assert(title != null);
    final stackTrace = StackTrace.current.toString();
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
                ? Scrollbar(
                    child: SingleChildScrollView(
                      child: Text(
                        withStackTrace
                            ? "${content}\n\n${stackTrace}"
                            : content,
                        style: StyleProvider.of(context)
                            .font
                            .normal
                            .copyWith(fontSize: 13),
                      ),
                    ),
                  )
                : null,
            actions: <Widget>[
              FlatButton(
                child: Text(
                  confirmLabel.toUpperCase(),
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
                    cancelLabel.toUpperCase(),
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
