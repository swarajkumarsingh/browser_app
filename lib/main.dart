import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'constants/http_override.dart';
import 'error_tracker/error_tracker.dart';
import 'firebase_options.dart';
import 'my_app.dart';

Future<void> main() async => _init();

Future<void> _init() async {
  HttpOverrides.global = MyHttpOverrides();
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // add error observers & handle them
    await errorTracker.handleError();

    runApp(const AppWrapper());
  }, errorTracker.captureError);
}
