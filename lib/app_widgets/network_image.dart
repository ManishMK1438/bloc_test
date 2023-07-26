import 'package:bloc_test/app_widgets/loader/app_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppNetworkImage extends StatelessWidget {
  final String url;
  final Widget? errorWidget;
  final BoxFit? fit;
  const AppNetworkImage(
      {super.key, required this.url, this.errorWidget, this.fit});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit ?? BoxFit.fill,
      placeholder: (context, url) => const ImageLoader(),
      errorWidget: (context, url, error) =>
          errorWidget ?? const FaIcon(FontAwesomeIcons.userTie),
    );
  }
}
