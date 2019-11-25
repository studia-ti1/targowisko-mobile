import 'package:flutter/material.dart';
import 'package:targowisko/utils/style_provider.dart';

class Input extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final bool enabled;
  final bool obscureText;
  final bool withBorder;
  final String title;
  final int lines;
  final TextInputType keyboardType;

  Input({
    this.placeholder,
    this.controller,
    this.enabled,
    this.title,
    this.keyboardType,
    this.lines = 1,
    this.obscureText = false,
    this.withBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              title,
              style: StyleProvider.of(context)
                  .font
                  .pacifico
                  .copyWith(fontSize: 16),
            ),
          ),
        TextField(
          maxLines: lines,
          minLines: lines,
          keyboardType: keyboardType,
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
        ),
      ],
    );
  }
}
