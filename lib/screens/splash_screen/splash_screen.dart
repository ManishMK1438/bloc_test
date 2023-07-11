import 'package:bloc_test/utils/colors.dart';
import 'package:bloc_test/utils/fonts.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final Fonts _fonts = Fonts();

  double w = 0;
  double h = 0;
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/splash_bg.png",
            fit: BoxFit.fitWidth,
            width: w,
          ),
          Container(
            // height: h / 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white10, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.5]),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: 300,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                Text(
                  "FoodNinja",
                  style: _fonts.vigaFont(
                      size: 40,
                      color: k53E88B,
                      weight: FontWeight.w400,
                      spacing: 0.5,
                      shadow: [
                        const Shadow(
                          offset: Offset(0.0, 2.0),
                          blurRadius: 8.0,
                          color: Colors.black45,
                        )
                      ]),
                ),
                Text(
                  "Deliver favourite food",
                  style: _fonts.inter(
                      size: 13,
                      weight: FontWeight.w600,
                      spacing: 1,
                      shadow: [
                        const Shadow(
                          offset: Offset(0.0, 1.0),
                          blurRadius: 3.0,
                          color: Colors.black45,
                        )
                      ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
