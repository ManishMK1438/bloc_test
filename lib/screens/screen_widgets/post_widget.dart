import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/home_states.dart';
import 'package:bloc_test/app_functions/app_functions.dart';
import 'package:bloc_test/app_widgets/network_image.dart';
import 'package:bloc_test/models/post_model/post_model.dart';
import 'package:bloc_test/utils/fonts.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../app_blocs/screen_blocs/home_bloc/home_bloc.dart';

class PostWidget extends StatelessWidget {
  final PostModel model;
  final int index;
  const PostWidget({super.key, required this.model, required this.index});

  Widget _postTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 24,
        child: AppNetworkImage(url: model.user!.profilePic ?? ""),
      ),
      title: Text(
        model.user!.name ?? AppStrings.user,
        style: Fonts().inter(size: 16),
      ),
      subtitle: Text(
        AppFunctions().timeAgo(dateTime: model.postedOn!),
        style: Fonts().inter(size: 14),
      ),
      /* trailing: PopupMenuButton(
          itemBuilder: (ctx) => [
                PopupMenuItem(child: Text("data")),
              ]),*/
    );
  }

  Widget _postMedia() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.desc ?? "",
          style: Fonts().inter(size: 18),
        ),
        const SizedBox(
          height: 20,
        ),
        AspectRatio(
          aspectRatio: 1.5,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: AppNetworkImage(url: model.image ?? ""),
          ),
        ),
      ],
    );
  }

  Widget _postInteractions(BuildContext context) {
    return BlocConsumer<HomeBloc, ValidHomeState>(
        listener: (ctx, state) {},
        // buildWhen: (previous, current) => current.isLiked != previous.isLiked,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Tooltip(
                message: AppStrings.like,
                child: TextButton.icon(
                    onPressed: () {},
                    icon: model.likedByMe!
                        ? const FaIcon(FontAwesomeIcons.solidThumbsUp)
                        : const FaIcon(FontAwesomeIcons.thumbsUp),
                    label: Text("${model.likes ?? 0} ${AppStrings.like}")),
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
                    icon: model.saved!
                        ? const FaIcon(FontAwesomeIcons.solidBookmark)
                        : const FaIcon(FontAwesomeIcons.bookmark),
                    label: model.saved!
                        ? const Text(AppStrings.saved)
                        : const Text(AppStrings.save)),
              ),
            ],
          );
        });
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
          _postInteractions(context)
        ],
      ),
    );
  }
}
