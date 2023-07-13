import 'package:flutter/material.dart';

class TextFieldDecoration {
  InputDecoration decoration({
    required String labelText,
    String? hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      suffixIcon: suffixIcon,
    );
  }
}
