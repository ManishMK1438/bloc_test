import 'package:flutter/material.dart';

class TextFieldDecoration {
  InputDecoration decoration(
      {required String labelText,
      String? hintText,
      Widget? suffixIcon,
      InputBorder? borer,
      FloatingLabelBehavior? behavior}) {
    return InputDecoration(
      border: borer,
      floatingLabelBehavior: behavior ?? FloatingLabelBehavior.always,
      labelText: labelText,
      hintText: hintText,
      suffixIcon: suffixIcon,
    );
  }
}
