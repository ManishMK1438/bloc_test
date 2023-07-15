import 'package:bloc_test/app_blocs/screen_blocs/tabs_bloc/tab_events.dart';
import 'package:bloc_test/app_blocs/screen_blocs/tabs_bloc/tabs_bloc.dart';
import 'package:bloc_test/screens/dashboard_screens/chat_screen.dart';
import 'package:bloc_test/screens/dashboard_screens/feed_screen.dart';
import 'package:bloc_test/screens/dashboard_screens/home_screen.dart';
import 'package:bloc_test/screens/dashboard_screens/profile_screen.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../app_blocs/screen_blocs/tabs_bloc/tab_state.dart';

class TabsScreen extends StatelessWidget {
  TabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabsBloc, TabState>(builder: (context, state) {
      if (state is TabChangedState) {
        return Scaffold(
          body: [HomeScreen(), FeedScreen(), ChatScreen(), ProfileScreen()]
              .elementAt(state.index),
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.house), label: AppStrings.home),
              NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.film), label: AppStrings.feed),
              NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.message),
                  label: AppStrings.chat),
              NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.user),
                  label: AppStrings.profile),
            ],
            selectedIndex: state.index,
            onDestinationSelected: (ind) {
              BlocProvider.of<TabsBloc>(context)
                  .add(TabIndexChangedEvent(index: ind));
              //index = ind;
            },
          ),
        );
      } else {
        return Scaffold(
          body: [HomeScreen(), FeedScreen(), ChatScreen(), ProfileScreen()]
              .elementAt(0),
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.house), label: AppStrings.home),
              NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.film), label: AppStrings.feed),
              NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.message),
                  label: AppStrings.chat),
              NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.user),
                  label: AppStrings.profile),
            ],
            selectedIndex: 0,
            onDestinationSelected: (ind) {
              BlocProvider.of<TabsBloc>(context)
                  .add(TabIndexChangedEvent(index: ind));
              //index = ind;
            },
          ),
        );
      }
    });
  }
}
