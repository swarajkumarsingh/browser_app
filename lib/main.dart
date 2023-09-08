import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'core/config/firebase_options.dart';
import 'core/constants/http_override.dart';
import 'core/di/injection_container.dart';
import 'core/error_tracker/error_tracker.dart';
import 'my_app.dart';
import 'utils/download/downloader.dart';
import 'utils/hive/hive_service.dart';
import 'utils/orientation.dart';

Future<void> main() async => _init();

Future<void> _init() async {
  HttpOverrides.global = MyHttpOverrides();
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await DependencyInjection.setup();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await errorTracker.handleError();
    await hiveService.init();
    await Permission.storage.request();
    await Permission.microphone.request();
    await downloader.init();
    await FlutterDisplayMode.setHighRefreshRate();
    await setPreferredOrientations();
    runApp(const AppWrapper());
    FlutterError.demangleStackTrace = (StackTrace stack) {
      if (stack is stack_trace.Trace) return stack.vmTrace;
      if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
      return stack;
    };
  }, errorTracker.captureError);
}
