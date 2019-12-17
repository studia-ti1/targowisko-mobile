import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class SecondaryButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const SecondaryButton({
    Key key,
    @required this.loading,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        boxShadow: [StyleProvider.of(context).shadow.mainShadow],
        color: StyleProvider.of(context).colors.secondaryAccent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: <Widget>[
            Center(
              child: loading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                  : Text(
                      "Ustaw zdjęcie z FB",
                      style: StyleProvider.of(context).font.normal.copyWith(
                            fontSize: 16,
                            color:
                                StyleProvider.of(context).colors.primaryContent,
                          ),
                    ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
              ),
            )
          ],
        ),
      ),
    );
  }
}
