import 'package:bloc_test/app_blocs/screen_blocs/content_blocs/post_screen_bloc/post_bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/content_blocs/upload_reel_bloc/reel_bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/home_bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/home_states.dart';
import 'package:bloc_test/app_widgets/app_bar.dart';
import 'package:bloc_test/app_widgets/error_widgets/app_error_widgets.dart';
import 'package:bloc_test/app_widgets/loader/app_loader.dart';
import 'package:bloc_test/local_storage/hive/hive_class.dart';
import 'package:bloc_test/screens/add_content_screens/add_post_screen.dart';
import 'package:bloc_test/screens/add_content_screens/add_shorts_screen.dart';
import 'package:bloc_test/utils/constants.dart';
import 'package:bloc_test/utils/navigation_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../app_blocs/screen_blocs/home_bloc/home_events.dart';
import '../../app_blocs/screen_blocs/home_bloc/post_interaction_bloc/interaction_bloc.dart';
import '../../app_widgets/error_widgets/no_data_found.dart';
import '../../utils/fonts.dart';
import '../../utils/strings.dart';
import '../screen_widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime current = DateTime.now();

  late Stream<DateTime> timer;
  late final Box<dynamic> _userBox;
  _openBox() {
    _userBox = HiveClass().getBox(boxName: AppStr.userHiveBox);
  }

  @override
  void initState() {
    timer = Stream.periodic(const Duration(minutes: 1), (i) {
      current = current.add(const Duration(minutes: 1));
      return current;
    });
    _openBox();
    super.initState();
  }

  String _greetings(DateTime snap) {
    var hour = snap.hour;
    final user = _userBox.getAt(0);
    if (hour < 12) {
      return "${AppStrings.goodMorning}, ${user?.name ?? AppStrings.user}";
    }
    if (hour < 16) {
      return "${AppStrings.goodAfternoon}, ${user?.name ?? AppStrings.user}";
    }
    if (hour < 20) {
      return "${AppStrings.goodEvening}, ${user?.name ?? AppStrings.user}";
    }
    return "${AppStrings.sleepWell}, ${user?.name ?? AppStrings.user}";
  }

  String _images(DateTime snap) {
    var hour = snap.hour;
    if (hour < 12) {
      return AppImages.morning;
    }
    if (hour < 16) {
      return AppImages.afternoon;
    }
    if (hour < 20) {
      return AppImages.evening;
    }
    return AppImages.night;
  }

  _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
              margin: const EdgeInsets.all(appPadding),
              padding: const EdgeInsets.all(appPadding),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(defaultRadius)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {
                      AppNavigation.push(
                          context: context,
                          screen: BlocProvider(
                            create: (context) => PostBloc(),
                            child: AddPostScreen(),
                          ));
                    },
                    leading: const FaIcon(FontAwesomeIcons.photoFilm),
                    title: Text(
                      AppStrings.post,
                      style: Fonts().inter(size: 18),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      AppNavigation.push(
                          context: context,
                          screen: BlocProvider(
                              create: (context) => UploadReelBloc(),
                              child: AddShortsScreen()));
                    },
                    leading: const FaIcon(FontAwesomeIcons.fileVideo),
                    title: Text(
                      AppStrings.shorts,
                      style: Fonts().inter(size: 18),
                    ),
                  ),
                ],
              ),
            ));
  }

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
              StreamBuilder<DateTime>(
                  stream: timer,
                  builder: (context, snapShot) {
                    return CustomSliverAppBar(
                      implyLeading: false,
                      expandedHeight: sliverExpandedHeight,
                      floating: true,
                      backgroundColor: Colors.black,
                      shadowColor: Colors.transparent,
                      pinned: true,
                      elevation: 0,
                      flexibleWidget: FlexibleSpaceBar(
                        titlePadding:
                            const EdgeInsets.only(left: 15, bottom: 10),
                        title: FittedBox(
                          child: Text(
                            _greetings(snapShot.data ?? DateTime.now()),
                            style:
                                Fonts().vigaFont(size: 20, color: Colors.white),
                          ),
                        ),
                        background: Image.asset(
                            _images(snapShot.data ?? DateTime.now()),
                            fit: BoxFit.fill,
                            color: Colors.black26,
                            colorBlendMode: BlendMode.darken),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            _showBottomSheet();
                            /*FirebaseAuth.instance.signOut().then((value) {
                              AppNavigation.pushAndRemove(
                                  context: context,
                                  screen: BlocProvider(
                                    create: (context) => LoginBloc(),
                                    child: LoginScreen(),
                                  ));
                            }).catchError((error) {
                              print(error.toString());
                            });*/
                          },
                          tooltip: AppStrings.addPost,
                          icon: const FaIcon(FontAwesomeIcons.plus),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white.withOpacity(0.4)),
                          ),
                          color: Colors.white,
                        )
                      ],
                    );
                  })
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(left: appPadding, right: appPadding),
            child: BlocConsumer<HomeBloc, ValidHomeState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state.status == PostStatus.loading) {
                    return const AppLoader();
                  } else if (state.status == PostStatus.failure) {
                    return AppErrorWidget(error: state.error);
                  } else if (state.status == PostStatus.success) {
                    return LazyLoadScrollView(
                      onEndOfPage: () {
                        BlocProvider.of<HomeBloc>(context)
                            .add(LoadInitialDataHomeEvent(refresh: false));
                      },
                      isLoading: false,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<HomeBloc>(context)
                              .add(LoadInitialDataHomeEvent(refresh: true));
                        },
                        child: ListView.separated(
                          separatorBuilder: (ctx, ind) => const Divider(),
                          itemBuilder: (ctx, index) {
                            if (index < state.posts.length) {
                              var post = state.posts[index];
                              return BlocProvider(
                                create: (BuildContext context) =>
                                    PostInteractionBloc(),
                                child: PostWidget(
                                  model: post,
                                  index: index,
                                ),
                              );
                            } else if (state.hasReachedMax) {
                              return Text(
                                AppStrings.scrollEnd,
                                textAlign: TextAlign.center,
                                style: Fonts().inter(size: 14),
                              );
                            } else {
                              return const Center(child: ScrollLoader());
                            }
                          },
                          itemCount: state.posts.toSet().toList().length + 1,
                        ),
                      ),
                    );
                  }
                  return const NoDataFoundWidget();
                }),
          ),
        ),
      ),
    );
  }
}
