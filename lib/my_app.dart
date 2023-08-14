import 'core/event_tracker/event_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

import 'core/constants/constants.dart';
import 'presentation/view/home/home_screen.dart';
import 'router.dart';
import 'utils/restart/restart_widget.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const RestartWidget(child: MyApp());
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
    return MaterialApp(
      title: 'Browser App',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      onGenerateRoute: (settings) => generateRoute(settings),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const HomScreen(),
    );
  }
}
