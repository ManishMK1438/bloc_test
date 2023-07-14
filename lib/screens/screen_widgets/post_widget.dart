import 'package:bloc_test/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  Widget _postTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.black38,
      ),
      title: Text("data"),
      subtitle: Text("data"),
      trailing: PopupMenuButton(
          itemBuilder: (ctx) => [
                PopupMenuItem(child: Text("data")),
              ]),
    );
  }

  Widget _postMedia() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Image.asset(
          "assets/images/morning.jpg",
          fit: BoxFit.fill,
          errorBuilder: (c, v, b) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _postInteractions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Tooltip(
          message: AppStrings.like,
          child: TextButton.icon(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.thumbsUp),
              label: const Text(AppStrings.like)),
        ),
        Tooltip(
          message: AppStrings.comment,
          child: TextButton.icon(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.solidCommentDots),
              label: const Text(AppStrings.comment)),
        ),
        Tooltip(
          message: AppStrings.save,
          child: TextButton.icon(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.bookmark),
              label: const Text(AppStrings.save)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _postTile(),
          const SizedBox(
            height: 10,
          ),
          _postMedia(),
          const SizedBox(
            height: 10,
          ),
          _postInteractions()
        ],
      ),
    );
  }
}
