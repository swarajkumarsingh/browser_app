// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

const String sentryEnvironment = "staging";
const String sentryDSN =
    "https://eed1da5969630f389c729af90d2b3ae3@o4505619587989504.ingest.sentry.io/4505619589038080";
const int maxNumberOfRestartTries = 3;

const apkDownloadLink =
    "https://files.an1.co/minecraft-mod_1.20.15.01-an1.com.apk";
const imageUrlLink =
    "https://images.pexels.com/photos/895259/pexels-photo-895259.jpeg?cs=srgb&dl=pexels-dominika-roseclay-895259.jpg&fm=jpg";

const googleUrl = "https://google.com";

class Constants {
  Constants._();

  static String downloadImageUrl =
      "https://gc-strapi-production.s3.eu-west-2.amazonaws.com/Partners_network_installation_icon_92a8e01da7.jpg";

// AdBlocker Preferences
  static String PREF_TOTAL_ADS_BLOCKED = "pref_total_ads_blocked";
  static String PREF_TOTAL_AD_BLOCKER_ENABLED = "pref_total_ad_blocker_enabled";
  static String PREF_TOTAL_PAGE_VISITED = "pref_total_page_visited";
  static String PREF_TOTAL_ADS_SIZE_SAVED = "pref_total_ads_size_saved";
  static String PREF_TOTAL_ADS_TIME_SAVED = "pref_total_ads_time_saved";

  // Browser Preferences
  static String PREF_WEBVIEW_MAX_RE_TRIES = "pref_webview_max_re_tries";
  static String PRE_BROWSER_FILES_DOWNLOADED = "browser_files_downloaded";

  // Hive Preferences
  static String HISTORY_BOX = "history_box";
  static String TABS_BOX = "tabs_box";
  static String HOME_IMAGE_BOX = "home_image";
  static String CURRENT_TAB_INDEX_BOX = "current_tab_index";

  static String DOWNLOAD_SAVE_BOX = "download_save_box";
  static String DOWNLOADING_SAVE_BOX = "downloading_save_box";
}
