import 'package:flutter/material.dart';

class AppFormFieldHelper {
  AppFormFieldHelper._();

  static InputDecoration decoration({
    required BuildContext context,
    required String label,
    bool required = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? hintText,
    InputBorder? border,
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintText: hintText,
      border: border ?? const OutlineInputBorder(),
      label: RichText(
        text: TextSpan(
          text: label,
          style: Theme.of(context).inputDecorationTheme.labelStyle,
          children: required
              ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}
