import 'package:bloc_test/utils/fonts.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:flutter/material.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AppImages.notFound),
        const SizedBox(
          height: 50,
        ),
        Text(
          AppStrings.noDataFound,
          style: Fonts().inter(size: 18),
        )
      ],
    );
  }
}
