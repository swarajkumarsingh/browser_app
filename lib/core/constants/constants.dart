import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

const String sentryEnvironment = "staging";
const String sentryDSN =
    "https://eed1da5969630f389c729af90d2b3ae3@o4505619587989504.ingest.sentry.io/4505619589038080";
const int maxNumberOfRestartTries = 3;
