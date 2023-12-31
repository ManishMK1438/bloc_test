import 'package:bloc_test/app_blocs/bloc_observer.dart';
import 'package:bloc_test/app_blocs/connectivity_blocs/internet_blocs.dart';
import 'package:bloc_test/app_blocs/screen_blocs/feed_bloc/feed_bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/home_bloc/home_bloc.dart';
import 'package:bloc_test/local_storage/hive/hive_class.dart';
import 'package:bloc_test/models/user_model/user_model.dart';
import 'package:bloc_test/notification.dart';
import 'package:bloc_test/screens/dashboard_screens/tabs_screen.dart';
import 'package:bloc_test/screens/splash_screen/splash_screen.dart';
import 'package:bloc_test/utils/colors.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'app_blocs/screen_blocs/tabs_bloc/tabs_bloc.dart';
import 'app_widgets/error_widgets/app_error_widgets.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {};
  ErrorWidget.builder = (FlutterErrorDetails details) =>
      AppErrorWidget(error: details.exception.toString());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  await HiveClass().init();
  Hive.registerAdapter(UserModelAdapter());
  await HiveClass().openBox(boxName: AppStr.userHiveBox);
  Bloc.observer = GlobalObserver();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void dispose() {
    HiveClass().closeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => InternetBloc()),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => FeedBloc(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: primaryColor,
          ),
          navigatorKey: navigatorKey,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
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
