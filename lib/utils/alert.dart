import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:targowisko/screens/home/home_screen.dart';
import 'package:targowisko/utils/api.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/animated/rate_coins.dart';

typedef OnRate<T> = Future<T> Function(Rate rate);

class Rate {
  Rate({
    @required this.rate,
    @required this.comment,
  });

  final int rate;

  final String comment;

  @override
  String toString() {
    return {
      "comment": comment,
      "rate": rate,
    }.toString();
  }
}

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
            elevation: 0,
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

  static Future<void> openRateModal<T>(
    BuildContext context, {
    @required String title,
    @required OnRate<T> onRate,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: RateDialogContent<T>(
              title: title,
              onRate: onRate,
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

class RateDialogContent<T> extends StatefulWidget {
  final String title;
  final OnRate<T> onRate;

  const RateDialogContent({
    Key key,
    @required this.title,
    @required this.onRate,
  }) : super(key: key);

  @override
  _RateDialogContentState createState() => _RateDialogContentState();
}

class _RateDialogContentState extends State<RateDialogContent>
    with TickerProviderStateMixin {
  int _rate;
  String _comment;
  int _step = 0;
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 0.0,
      lowerBound: 0,
      upperBound: 2.0,
    );
    _controller.animateTo(
      1.0,
      duration: const Duration(milliseconds: 1600),
      curve: Curves.elasticOut,
    );
  }

  void _onCoinRate(int rate) {
    setState(() {
      _step = 1;
      _rate = rate;
    });
  }

  void _onComment(String comment) async {
    setState(() {
      _comment = comment;
      _step = 2;
    });
    final rate = Rate(comment: _comment, rate: _rate);
    try {
      await widget.onRate(rate);
    } on ApiException catch (err) {
      Alert.open(
        context,
        title: "Wystąpił błąd podczas oceniania",
        confirmLabel: "Rozumiem",
        content: err.message,
      );
      setState(() {
        _step = 0;
      });
      return;
    } on Exception catch (err) {
      Alert.open(
        context,
        title: "Wystąpił błąd podczas oceniania",
        confirmLabel: "Rozumiem",
        content: err.toString(),
      );
      setState(() {
        _step = 0;
      });
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [StyleProvider.of(context).shadow.mainShadow],
          color: Colors.white,
        ),
        child: AnimatedSize(
          alignment: Alignment.topCenter,
          curve: Curves.elasticOut,
          vsync: this,
          duration: const Duration(milliseconds: 900),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  textAlign: TextAlign.left,
                  style: StyleProvider.of(context).font.pacifico.copyWith(
                        fontSize: 20,
                      ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (_step < 2)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _step == 0
                      ? RateCoins(
                          onRate: _onCoinRate,
                        )
                      : CommentElem(
                          onComment: _onComment,
                        ),
                )
              else
                CustomLoader(
                  loadingText: "wystawianie oceny",
                ),
            ],
          ),
        ),
      ),
      builder: (context, widget) {
        return ScaleTransition(scale: _controller, child: widget);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
