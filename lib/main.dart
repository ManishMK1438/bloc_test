import 'package:bloc_test/app_blocs/connectivity_blocs/internet_blocs.dart';
import 'package:bloc_test/screens/dashboard_screens/tabs_screen.dart';
import 'package:bloc_test/screens/splash_screen/splash_screen.dart';
import 'package:bloc_test/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_blocs/screen_blocs/tabs_bloc/tabs_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InternetBloc(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: primaryColor,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return BlocProvider(
                  create: (context) => TabsBloc(),
                  child: TabsScreen(),
                );
              } else {
                return const SplashScreen();
              }
            },
          )

          /* BlocListener<InternetBloc, InternetState>(
          bloc: InternetBloc(),
          listener: (BuildContext context, state) {
            print(state.runtimeType);
            if (state is InternetLostState) {
              AppNavigation.push(context: context, screen: NoInternetScreen());
            } else if (state is InternetGainedState) {
              AppNavigation.pushAndRemove(
                  context: context,
                  screen: BlocProvider(
                    create: (context) => TabsBloc(),
                    child: TabsScreen(),
                  ));
            }
          },
          child: SplashScreen(),
        ),*/
          ),
    );
  }
}
