import 'package:bloc_test/screens/dashboard_screens/chat_screen.dart';
import 'package:bloc_test/screens/dashboard_screens/feed_screen.dart';
import 'package:bloc_test/screens/dashboard_screens/home_screen.dart';
import 'package:bloc_test/screens/dashboard_screens/profile_screen.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatelessWidget {
  TabsScreen({super.key});

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [HomeScreen(), FeedScreen(), ChatScreen(), ProfileScreen()]
          .elementAt(index),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_filled), label: AppStrings.home),
          NavigationDestination(icon: Icon(Icons.feed), label: AppStrings.feed),
          NavigationDestination(
              icon: Icon(Icons.chat_outlined), label: AppStrings.chat),
          NavigationDestination(
              icon: Icon(Icons.person), label: AppStrings.profile),
        ],
        selectedIndex: index,
        onDestinationSelected: (ind) {
          index = ind;
        },
      ),
    );
  }
}
