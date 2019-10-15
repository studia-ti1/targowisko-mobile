import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class Input extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final bool enabled;
  final bool obscureText;

  Input({
    this.placeholder,
    this.controller,
    this.enabled,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: placeholder,
        border: StyleProvider.of(context).border.input.primary,
        enabledBorder: StyleProvider.of(context).border.input.primary,
        disabledBorder: StyleProvider.of(context).border.input.primary,
        focusedBorder: StyleProvider.of(context).border.input.primary,
      ),
    );
  }
}
