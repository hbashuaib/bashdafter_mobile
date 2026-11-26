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

      labelText: required ? '$label *' : label,

      floatingLabelStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
