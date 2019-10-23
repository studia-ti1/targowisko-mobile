import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class PrimaryButton extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback onPressed;
  final bool loading;
  final Widget icon;

  PrimaryButton({
    this.color,
    this.icon,
    @required this.label,
    @required this.onPressed,
    this.loading,
  }) : assert(label != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [StyleProvider.of(context).shadow.mainShadow],
          borderRadius: BorderRadius.circular(50)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: color ?? StyleProvider.of(context).colors.primaryAccent,
          ),
          child: RawMaterialButton(
            child: loading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                        StyleProvider.of(context).colors.primaryContent),
                  )
                : Stack(
                    children: [
                      if (icon != null) icon,
                      Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            color:
                                StyleProvider.of(context).colors.primaryContent,
                          ),
                        ),
                      ),
                    ],
                  ),
            onPressed: loading ? null : onPressed,
          ),
        ),
      ),
    );
  }
}
