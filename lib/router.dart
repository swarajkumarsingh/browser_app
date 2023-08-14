import 'core/common/widgets/error_screen.dart';
import 'presentation/view/home/home_screen.dart';
import 'presentation/view/search/search_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const HomScreen(),
      );

    case SearchScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const ErrorScreen(
          message: "404 Page not found :(",
        ),
      );
  }
}
