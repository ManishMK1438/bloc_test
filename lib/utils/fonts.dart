import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Fonts {
  TextStyle vigaFont(
      {required double size,
      Color? color,
      FontStyle? style,
      FontWeight? weight,
      List<Shadow>? shadow,
      double? spacing,
      double? height}) {
    return GoogleFonts.viga(
        fontSize: size,
        color: color,
        fontStyle: style ?? FontStyle.normal,
        fontWeight: weight ?? FontWeight.normal,
        letterSpacing: spacing,
        height: height,
        shadows: shadow);
  }

  TextStyle inter(
      {required double size,
      Color? color,
      FontStyle? style,
      FontWeight? weight,
      List<Shadow>? shadow,
      double? spacing,
      double? height}) {
    return GoogleFonts.inter(
        fontSize: size,
        color: color,
        fontStyle: style ?? FontStyle.normal,
        fontWeight: weight ?? FontWeight.normal,
        letterSpacing: spacing,
        height: height,
        shadows: shadow);
  }
}
