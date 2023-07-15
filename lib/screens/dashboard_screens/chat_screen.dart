import 'package:bloc_test/utils/colors.dart';
import 'package:bloc_test/utils/constants.dart';
import 'package:bloc_test/utils/fonts.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  Widget _stories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: appPadding),
          child: Text(
            AppStrings.stories,
            style: Fonts().vigaFont(size: 22),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 50,
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) => _buildStoryWidget(),
              separatorBuilder: (ctx, ind) => const SizedBox(
                    width: 12,
                  ),
              itemCount: 10),
        ),
      ],
    );
  }

  Widget _buildStoryWidget() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: primaryColor, width: 3.0),
      ),
      child: const CircleAvatar(
        radius: 25,
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _chats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: appPadding),
          child: Text(
            AppStrings.messages,
            style: Fonts().vigaFont(size: 22),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: appPadding),
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (ctx, index) => _chatWidget(),
              separatorBuilder: (ctx, ind) => Divider(),
              itemCount: 20),
        )
      ],
    );
  }

  Widget _chatWidget() {
    return const ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.black38,
      ),
      title: Text("data"),
      subtitle: Text("message"),
      trailing: Text("11:00 am"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _stories(),
              const Divider(),
              _chats(),
            ],
          ),
        ),
      ),
    );
  }
}
