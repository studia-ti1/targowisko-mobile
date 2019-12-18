import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class Alert {
  Alert._();

  static Future<bool> loader(BuildContext context, String title) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: StyleProvider.of(context).colors.primaryBackground,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    StyleProvider.of(context).asset.spinner,
                    width: 100,
                    fit: BoxFit.contain,
                    color: Colors.black,
                    colorBlendMode: BlendMode.color,
                    repeat: ImageRepeat.noRepeat,
                    filterQuality: FilterQuality.medium,
                    height: 100,
                  ),
                  SizedBox(height: 15),
                  AutoSizeText(
                    title,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: StyleProvider.of(context)
                        .font
                        .pacifico
                        .copyWith(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<bool> open(
    BuildContext context, {
    @required String title,
    String content,
    VoidCallback onConfirm,
    VoidCallback onCancel,
    String confirmLabel = "akceptuj",
    String cancelLabel,
    bool withStackTrace = true,
  }) {
    assert(title != null);
    final stackTrace = StackTrace.current.toString();
    return showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, false);
              return false;
            },
            child: AlertDialog(
              title: Text(
                title,
                style:
                    StyleProvider.of(context).font.bold.copyWith(fontSize: 16),
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
                  onPressed: onConfirm ?? () => Navigator.pop(context, true),
                ),
                if (cancelLabel != null)
                  FlatButton(
                    child: Text(
                      cancelLabel.toUpperCase(),
                      style: StyleProvider.of(context)
                          .font
                          .bold
                          .copyWith(fontSize: 13),
                    ),
                    onPressed: onCancel ?? () => Navigator.pop(context, false),
                  ),
              ],
            ),
          );
        });
  }
}
