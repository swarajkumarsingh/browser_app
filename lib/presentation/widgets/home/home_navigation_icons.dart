import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

import '../../view/search/search_screen.dart';

class PlusIconWidget extends StatelessWidget {
  const PlusIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Icon(
        Icons.add_circle_outlined,
        color: Colors.blue,
        size: 25,
      ),
    );
  }
}

class TabsNavigationIcon extends StatelessWidget {
  const TabsNavigationIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 0.5,
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: const Text(
          "1",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SearchNavigationIcon extends StatelessWidget {
  const SearchNavigationIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        appRouter.pushNamed(SearchScreen.routeName);
      },
      child: const Icon(
        Icons.search,
        size: 28,
      ),
    );
  }
}

class SettingsIconWidget extends StatelessWidget {
  const SettingsIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        appRouter.pushNamed(SearchScreen.routeName);
      },
      child: const Icon(Icons.settings),
    );
  }
}
