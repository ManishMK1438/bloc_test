import 'package:bloc_test/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/fonts.dart';

class AppButtons {
  Widget primaryButton(
      {Function()? onTap,
      required String text,
      TextStyle? style,
      double? elevation,
      EdgeInsetsGeometry? padding,
      ShapeBorder? shape,
      required Color color}) {
    return MaterialButton(
      elevation: elevation ?? 0,
      disabledColor: disabledButtonColor,
      padding: padding ??
          const EdgeInsets.symmetric(
              horizontal: buttonHorizontalPadding,
              vertical: buttonVerticalPadding),
      onPressed: onTap,
      shape: shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color,
      child: Text(
        text,
        style: style ?? Fonts().inter(size: 18, color: primaryButtonTextColor),
      ),
    );
  }
}
