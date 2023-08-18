import 'package:flutter/material.dart';

import 'core/common/widgets/error_screen.dart';
import 'presentation/view/home/home_screen.dart';
import 'presentation/view/search/search_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );

    case SearchScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      );

    // case SearchScreenWebview.routeName:
    //   return MaterialPageRoute(
    //     builder: (context) => const SearchScreenWebview(),
    //   );

    // case WebviewScreen.routeName:
    //   return MaterialPageRoute(
    //     builder: (context) => const WebviewScreen(),
    //   );

    default:
      return MaterialPageRoute(
        builder: (context) => const ErrorScreen(
          message: "404 Page not found :(",
        ),
      );
  }
}
