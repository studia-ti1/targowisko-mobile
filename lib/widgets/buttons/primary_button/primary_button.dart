import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class PrimaryButton extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback onPressed;
  final bool loading;

  PrimaryButton({
    this.color,
    @required this.label,
    @required this.onPressed,
    this.loading,
  }) : assert(label != null);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: color ?? StyleProvider.of(context).appColors.primaryAccent,
        ),
        child: RawMaterialButton(
          child: loading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                      StyleProvider.of(context).appColors.primaryContent),
                )
              : Text(
                  label,
                  style: TextStyle(
                    color: StyleProvider.of(context).appColors.primaryContent,
                  ),
                ),
          onPressed: loading ? null : onPressed,
        ),
      ),
    );
  }
}
