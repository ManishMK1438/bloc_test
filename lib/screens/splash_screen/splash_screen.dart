import 'package:bloc_test/screens/sign_in_screens/login_screen/login_screen.dart';
import 'package:bloc_test/utils/colors.dart';
import 'package:bloc_test/utils/fonts.dart';
import 'package:bloc_test/utils/navigation_file.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Fonts _fonts = Fonts();

  @override
  void initState() {
    _navigate();
    super.initState();
  }

  _navigate() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        AppNavigation.pushReplacement(context: context, screen: LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppImages.splashBG,
            fit: BoxFit.fitWidth,
            width: width,
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
                  AppImages.appLogo,
                  width: 300,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                Text(
                  AppStrings.splashTitle,
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
                  AppStrings.splashSubTitle,
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
