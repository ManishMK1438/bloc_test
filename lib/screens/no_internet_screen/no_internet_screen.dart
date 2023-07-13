import 'package:bloc_test/utils/strings.dart';
import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AppImages.noInternet),
      ),
    );
  }
}
