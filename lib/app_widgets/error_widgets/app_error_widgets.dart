import 'package:bloc_test/utils/fonts.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String error;
  const AppErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AppImages.error),
        const SizedBox(
          height: 50,
        ),
        Text(
          error,
          style: Fonts().inter(size: 18),
        )
      ],
    );
  }
}
