import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/color.dart';
import 'core/constants/constants.dart';
import 'core/event_tracker/event_tracker.dart';
import 'presentation/view/home/home_screen.dart';
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
      builder: (_, box, __) {
        final darkMode = box.get(Constants.DARK_MODE_BOX, defaultValue: false);
        return MaterialApp(
          theme: themeData(),
          title: 'Browser App',
          home: const HomeScreen(),
          darkTheme: darkThemeData(),
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: scaffoldMessengerKey,
          onGenerateRoute: (settings) => generateRoute(settings),
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }

  ThemeData darkThemeData() {
    return ThemeData(
          primaryColor: Colors.deepPurple,
          brightness: Brightness.dark,
          useMaterial3: true,
        );
  }

  ThemeData themeData() {
    return ThemeData(
          useMaterial3: true,
          primaryColor: Colors.white,
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: colors.white,
            background: colors.white,
          ),
        );
  }
}
