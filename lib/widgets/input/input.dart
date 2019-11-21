import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class Input extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final bool enabled;
  final bool obscureText;
  final bool withBorder;

  Input({
    this.placeholder,
    this.controller,
    this.enabled,
    this.obscureText = false,
    this.withBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      minLines: 1,
      enabled: enabled,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        isDense: true,
        hintText: placeholder,
        border: withBorder
            ? StyleProvider.of(context).border.input.primary
            : StyleProvider.of(context).border.input.noBorder,
        enabledBorder: withBorder
            ? StyleProvider.of(context).border.input.primary
            : StyleProvider.of(context).border.input.noBorder,
        disabledBorder: withBorder
            ? StyleProvider.of(context).border.input.primary
            : StyleProvider.of(context).border.input.noBorder,
        focusedBorder: withBorder
            ? StyleProvider.of(context).border.input.primary
            : StyleProvider.of(context).border.input.noBorder,
      ),
    );
  }
}
