import 'package:bloc_test/app_blocs/screen_blocs/feed_bloc/feed_bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/feed_bloc/feed_event.dart';
import 'package:bloc_test/app_blocs/screen_blocs/feed_bloc/feed_state.dart';
import 'package:bloc_test/screens/screen_widgets/feed_short_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../app_widgets/error_widgets/app_error_widgets.dart';
import '../../app_widgets/error_widgets/no_data_found.dart';
import '../../app_widgets/loader/app_loader.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<FeedBloc, FeedState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == FeedStatus.loading) {
              return const AppLoader();
            } else if (state.status == FeedStatus.error) {
              return AppErrorWidget(error: state.error);
            } else if (state.status == FeedStatus.success) {
              return LazyLoadScrollView(
                onEndOfPage: () {
                  BlocProvider.of<FeedBloc>(context)
                      .add(const FeedEvent(isRefresh: false));
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<FeedBloc>(context)
                        .add(const FeedEvent(isRefresh: true));
                  },
                  child: PageView.builder(
                    itemCount: state.feed.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      if (index < state.feed.length) {
                        var reel = state.feed[index];
                        return FeedShortWidget(
                          reel: reel,
                        );
                      } else if (state.hasReachedMax) {
                        return const SizedBox.shrink();
                      } else {
                        return const Center(child: ScrollLoader());
                      }
                    },
                  ),
                ),
              );
            }
            return const NoDataFoundWidget();
          }),
    );
  }
}
