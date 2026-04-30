 

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:layer_kit/layer_kit.dart';
import 'package:myapp/config/lang/app_localization.dart';
import 'package:myapp/config/routes/routes.dart';
import 'package:myapp/config/theme/theme.dart';
import "package:myapp/core/callbacks/callbacks.dart";
import 'package:myapp/core/constants/app_constants.dart';
import 'package:myapp/core/helper/global_prefs.dart';
import 'package:myapp/src/home/home_bloc/home_bloc.dart';
import 'package:myapp/src/home/home_bloc/home_event.dart';
import 'package:myapp/src/splash/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import "package:toastification/toastification.dart";
import 'package:url_strategy/url_strategy.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'di_container.dart';
import 'notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// FIREBASE SETUP
  ///
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await _setupFirebaseCrashlytics();
  ///
  /// /////////////

  await Di.init();
  await GlobalPrefs.init();
  await AppLocalization.init();
  await AppTheme.init();
  await Hive.initFlutter();
  await Hive.openBox('meals');
  await Hive.openBox('favorites');
  await NotificationService.init();
  tz.initializeTimeZones();

  final granted = await NotificationService.requestPermission();

  if (granted) {
    await NotificationService.scheduleDaily(
      id: 1,
      hour: 8,
      minute: 0,
      title: "Breakfast 🍳",
      body: "Start your day with a healthy recipe!",
    );

    await NotificationService.scheduleDaily(
      id: 2,
      hour: 14,
      minute: 0,
      title: "Lunch 🍛",
      body: "Time for a delicious lunch!",
    );

    await NotificationService.scheduleDaily(
      id: 3,
      hour: 20,
      minute: 0,
      title: "Dinner 🍲",
      body: "End your day with a great meal!",
    );

    await NotificationService.scheduleDaily(
      id: 4,
      hour: 11,
      minute: 20,
      title: "Lunch 🍛",
      body: "Time for a delicious lunch!",
    );

    await NotificationService.scheduleDaily(
      id: 5,
      hour: 11,
      minute: 25,
      title: "Lunch 🍛",
      body: "Time for a delicious lunch! 11:25",
    );

    await NotificationService.scheduleDaily(
      id: 6,
      hour: 11,
      minute: 28,
      title: "Lunch 🍛",
      body: "Time for a delicious lunch! 11:28",
    );

    /// ------------------- just for testing ------------------- ///

    // final now = DateTime.now();
    // final testTime = now.add(const Duration(minutes: 1));
    //
    // await NotificationService.scheduleDaily(
    //   id: 99,
    //   hour: testTime.hour,
    //   minute: testTime.minute,
    //   title: "Test 🔥",
    //   body: "This is a test notification",
    // );
  } else {
    debugPrint("❌ Notification permission denied");
  }

  HttpOverrides.global = MyHttpOverrides();

  setPathUrlStrategy();
  runApp(
    MultiBlocProvider(
      providers: Di.blocProviders,
      child: AppLocalization(
        child: AppTheme(
          child: MyApp(),
        ),
      ),
    ),
  );
}

/// CODE FOR FIREBASE CRASHLYTICS
///
// Future<void> _setupFirebaseCrashlytics() async {
//   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
//   FlutterError.onError = (FlutterErrorDetails details) {
//     if (kDebugMode) {
//       FlutterError.dumpErrorToConsole(details);
//     } else {
//       FirebaseCrashlytics.instance.recordFlutterError(details);
//     }
//   };
//
//   PlatformDispatcher.instance.onError = (error, stack) {
//     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
//     return true;
//   };
// }
/// ////////////////////////////////////////

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    widgetBinding((_) {
      // CODE
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      // DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
    ]);

    ThemeConfig.init(context);
    RouteConfig.setDefaultTransition(TransitionType.fade);
    return ToastificationWrapper(
      child: MaterialApp(
        title: AppConsts.appName,
        navigatorKey: AppRouter.navigatorKey,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (s) => AppRouter.generateRoute(s, SplashScreen()),
        scrollBehavior: const StretchScrollBehavior(),
        initialRoute: Routes.splash.path,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: context.theme.currentTheme,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child ?? SizedBox(),
          );
        },
      ),
    );
  }
}
