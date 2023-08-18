// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

const String sentryEnvironment = "staging";
const String sentryDSN =
    "https://eed1da5969630f389c729af90d2b3ae3@o4505619587989504.ingest.sentry.io/4505619589038080";
const int maxNumberOfRestartTries = 3;

class Constants {
  Constants._();

// AdBlocker Preferences
  static String PREF_TOTAL_ADS_BLOCKED = "pref_total_ads_blocked";
  static String PREF_TOTAL_AD_BLOCKER_ENABLED = "pref_total_ad_blocker_enabled";
  static String PREF_TOTAL_PAGE_VISITED = "pref_total_page_visited";
  static String PREF_TOTAL_ADS_SIZE_SAVED = "pref_total_ads_size_saved";
  static String PREF_TOTAL_ADS_TIME_SAVED = "pref_total_ads_time_saved";

  // Browser Preferences
  static String PREF_WEBVIEW_MAX_RE_TRIES = "pref_webview_max_re_tries";
}
