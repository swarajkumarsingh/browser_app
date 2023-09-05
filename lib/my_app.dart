import 'package:browser_app/presentation/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/color.dart';
import 'core/constants/constants.dart';
import 'core/event_tracker/event_tracker.dart';
import 'router.dart';
import 'utils/restart/restart_widget.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: RestartWidget(child: MyApp()));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await eventTracker.logAppOpen();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(Constants.DARK_MODE_BOX).listenable(),
      builder: (context, box, widget) {
        final darkMode = box.get(Constants.DARK_MODE_BOX, defaultValue: false);
        return MaterialApp(
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(
            useMaterial3: true,
          ),
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: colors.white,
              background: colors.white,
            ),
          ),
          title: 'Browser App',
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: scaffoldMessengerKey,
          onGenerateRoute: (settings) => generateRoute(settings),
          home: const HomeScreen(),
        );
      },
    );
  }
}
