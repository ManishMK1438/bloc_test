import 'package:bloc_test/screens/screen_widgets/post_widget.dart';
import 'package:bloc_test/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../utils/fonts.dart';
import '../../utils/strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: sliverExpandedHeight,
                floating: true,
                backgroundColor: Colors.black,
                shadowColor: Colors.transparent,
                pinned: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 15, bottom: 10),
                  title: Text(
                    AppStrings.goodMorning,
                    style: Fonts().vigaFont(size: 20, color: Colors.white),
                  ),
                  //collapseMode: CollapseMode.pin,
                  background: Image.asset(AppImages.morning,
                      fit: BoxFit.fill,
                      color: Colors.black26,
                      colorBlendMode: BlendMode.darken),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add),
                    color: Colors.white,
                  )
                ],
              )
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(appPadding),
            child: LazyLoadScrollView(
              onEndOfPage: () {},
              isLoading: false,
              child: RefreshIndicator(
                onRefresh: () async {},
                child: ListView.separated(
                  separatorBuilder: (ctx, ind) => const Divider(),
                  //shrinkWrap: true,
                  itemBuilder: (ctx, index) => const PostWidget(),
                  itemCount: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
