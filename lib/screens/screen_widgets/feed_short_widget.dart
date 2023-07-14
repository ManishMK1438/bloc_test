import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedShortWidget extends StatelessWidget {
  const FeedShortWidget({super.key});

  Widget _feedInteractions() {
    return Positioned(
      left: 10,
      right: 10,
      bottom: 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [_shortsDetails(), _interactionButtons()],
      ),
    );
  }

  Widget _shortsDetails() {
    return Expanded(
      flex: 6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
            ),
            title: Text("Data"),
          ),
          InkWell(
            onTap: () {},
            child: AnimatedContainer(
              constraints: const BoxConstraints(maxHeight: 200),
              duration: const Duration(milliseconds: 100),
              child: const SingleChildScrollView(
                child: Text(
                  "akbhds kd cbvksdvbc s dcvsdg csd gcdv csskdu cvbzxjcask casb ckasb akbhds kd cbvksdvbc s dcvsdg csd gcdv csskdu cvbzxjcask casb ckasb akbhds kd cbvksdvbc s dcvsdg csd gcdv csskdu cvbzxjcask casb ckasb akbhds kd cbvksdvbc s dcvsdg csd gcdv csskdu cvbzxjcask casb ckasb akbhds kd cbvksdvbc s dcvsdg csd gcdv csskdu cvbzxjcask casb ckasb akbhds kd cbvksdvbc s dcvsdg csd gcdv csskdu cvbzxjcask casb ckasb akbhds kd cbvksdvbc s dcvsdg csd gcdv csskdu cvbzxjcask casb ckasb akbhds kd cbvksdvbc s dcvsdg csd gcdv csskdu cvbzxjcask casb ckasb akbhds kd cbvksdvbc s dcvsdg csd gcdv csskdu cvbzxjcask casb ckasb akbhds kd cbvksdvbc s dcvsdg csd gcdv csskdu cvbzxjcask casb ckasb akbhds kd cbvksdvbc s dcvsdg csd gcdv csskdu cvbzxjcask casb ckasb akbhds kd cbvksdvbc s dcvsdg csd gcdv csskdu cvbzxjcask casb ckasb cu asku ksa dbksaubbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbAUVXS SAUb sxuAV SUVAS U",
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _interactionButtons() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.heart)),
          IconButton(
              onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.comment)),
          IconButton(
              onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.share)),
          IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.ellipsisVertical)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey,
        ),
        _feedInteractions(),
      ],
    );
  }
}
