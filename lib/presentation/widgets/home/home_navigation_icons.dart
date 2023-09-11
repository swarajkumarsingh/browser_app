import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

import '../../../core/common/widgets/toast.dart';
import '../../view/settings/settings_screen.dart';
import '../../view/tab/tab_screen.dart';
import '../../viewModel/home_screen_view_model.dart';

class PlusNavigationIcon extends StatelessWidget {
  const PlusNavigationIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: const Icon(
        Icons.add_circle_outlined,
        color: Colors.blue,
        size: 25,
      ),
    );
  }
}

class HomeNavigationIcon extends StatelessWidget {
  const HomeNavigationIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.home_outlined,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white70
          : Colors.black,
      size: 25,
    );
  }
}

class SettingsNavigationIcon extends StatelessWidget {
  const SettingsNavigationIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => appRouter.push(const SettingsScreen()),
      child: Icon(
        Icons.settings,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black,
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
      onTap: () {
        showToast("under maintenance");
        appRouter.push(const TabsScreen());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 0.5,
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black,
            width: 2.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(
          "1",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black,
          ),
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
      onTap: homeViewModel.navigateToSearchScreen,
      child: Icon(
        Icons.search,
        size: 28,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black,
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
      onTap: homeViewModel.navigateToHistoryScreen,
      child: Icon(
        Icons.settings,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black,
      ),
    );
  }
}
