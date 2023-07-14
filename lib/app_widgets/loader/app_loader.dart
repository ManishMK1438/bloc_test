import 'package:bloc_test/utils/colors.dart';
import 'package:bloc_test/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoader extends StatelessWidget {
  final Color? bgColor;
  const AppLoader({super.key, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor ?? Colors.white.withOpacity(0.5),
      body: const Center(
        child: SpinKitRipple(
          color: secondaryColor,
          size: appLoaderSize,
        ),
      ),
    );
  }
}

class ButtonLoader extends StatelessWidget {
  final double? size;
  const ButtonLoader({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
      color: secondaryColor,
      size: size ?? defaultButtonLoaderSize,
    );
  }
}
