import 'package:flutter/material.dart';

import 'core/common/widgets/error_screen.dart';
import 'presentation/view/history/history_screen.dart';
import 'presentation/view/home/home_screen.dart';
import 'presentation/view/search/search_screen.dart';
import 'presentation/view/search/search_screen_webview.dart';
import 'presentation/view/webview/webview_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      );

    case SearchScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const SearchScreen(),
      );

    case HistoryScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const HistoryScreen(),
      );

    case SearchScreenWebview.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final prompt = arguments['prompt'];
      final url = arguments['url'];
      final focusTextfield = arguments['focusTextfield'];
      return MaterialPageRoute(
        builder: (_) => SearchScreenWebview(
          prompt: prompt,
          url: url,
          focusTextfield: focusTextfield ?? true,
        ),
      );

    case WebviewScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final url = arguments['url'];
      final query = arguments['query'];
      return MaterialPageRoute(
        builder: (_) => WebviewScreen(url: url, query: query),
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const ErrorScreen(
          message: "404 Page not found :(",
        ),
      );
  }
}
