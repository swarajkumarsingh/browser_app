import '../../utils/date/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:screenshot/screenshot.dart';

import '../config/keys.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

ScreenshotController screenshotController = ScreenshotController();

// Sentry config
const int maxNumberOfRestartTries = 3;
const String sentryEnvironment = "staging";
const String sentryDSN = sentryDSN_;

const googleUrl = "https://google.com";
const apkDownloadLink =
    "https://files.an1.co/minecraft-mod_1.20.15.01-an1.com.apk";
const imageUrlLink =
    "https://images.pexels.com/photos/895259/pexels-photo-895259.jpeg?cs=srgb&dl=pexels-dominika-roseclay-895259.jpg&fm=jpg";

String newsApiUrl =
    "https://newsapi.org/v2/everything?q=india&from=${getYesterdayDateForNewsApi()}&sortBy=publishedAt&apiKey=$news_api_key_";
const String newsTitleStatic = "Breaking News";
const String newsImageStatic =
    "https://awlights.com/wp-content/uploads/sites/31/2017/05/placeholder-news.jpg";

FlutterTts flutterTts = FlutterTts();

class Constants {
  Constants._();

  static const String downloadImageUrl =
      "https://gc-strapi-production.s3.eu-west-2.amazonaws.com/Partners_network_installation_icon_92a8e01da7.jpg";

  // AdBlocker Preferences
  static const String PREF_TOTAL_ADS_BLOCKED = "pref_total_ads_blocked";
  static const String PREF_TOTAL_PAGE_VISITED = "pref_total_page_visited";
  static const String PREF_TOTAL_ADS_SIZE_SAVED = "pref_total_ads_size_saved";
  static const String PREF_TOTAL_ADS_TIME_SAVED = "pref_total_ads_time_saved";
  static const String PREF_TOTAL_AD_BLOCKER_ENABLED =
      "pref_total_ad_blocker_enabled";

  // Browser Preferences
  static const String PREF_WEBVIEW_MAX_RE_TRIES = "pref_webview_max_re_tries";
  static const String PRE_BROWSER_FILES_DOWNLOADED = "browser_files_downloaded";

  // Hive Preferences
  static const String TABS_BOX = "tabs_box";
  static const String NEWS_BOX = "news_box";
  static const String HISTORY_BOX = "history_box";
  static const String DARK_MODE_BOX = "dark_mode";
  static const String HOME_IMAGE_BOX = "home_image";
  static const String DOWNLOAD_SAVE_BOX = "download_save_box";
  static const String CURRENT_TAB_INDEX_BOX = "current_tab_index";
  static const String DOWNLOADING_SAVE_BOX = "downloading_save_box";
}
