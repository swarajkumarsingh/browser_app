import 'package:flutter_approuter/flutter_approuter.dart';

import '../../../core/event_tracker/event_tracker.dart';
import 'package:flutter/material.dart';

import '../../../core/common/widgets/spaces.dart';
import '../../../core/constants/assets.dart';
import '../../../data/local/home_data_provider.dart';
import '../../widgets/home/home_navigation_icons.dart';
import '../../widgets/home/home_news_feed_widget.dart';
import '../../widgets/home/home_quick_links_wrap_widget.dart';
import '../../widgets/home/home_search_textfield.dart';
import '../search/search_screen.dart';

class HomScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomScreen({super.key});

  @override
  State<HomScreen> createState() => _HomScreenState();
}

class _HomScreenState extends State<HomScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await eventTracker.screen("home-screen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(),
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomNavigationBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// [Search Textfield]
              const HomeSearchTextField(),

              /// [Quick links]
              const HomeQuickLinkWrapWidget(),

              // Spacing
              const VerticalSpace(height: 20),

              /// [News widget]
              ...fakeNewsData.map(
                (e) => NewsWidget(
                  image: e.image,
                  description: e.description,
                  redirectUrl: e.redirectUrl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar homeAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset(Assets.fullLogo),
        ),
      ),
      title: const FittedBox(
        child: Text(
          "Browser App",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      elevation: 0,
      iconSize: 25,
      showSelectedLabels: false,
      useLegacyColorScheme: true,
      showUnselectedLabels: false,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      items: [
        homeNavigationIcon(),
        searchNavigationIcon(),
        plusNavigationIcon(),
        tabsNavigationIcon(),
        settingsNavigationBar(),
      ],
    );
  }

  BottomNavigationBarItem settingsNavigationBar() {
    return BottomNavigationBarItem(
      icon: GestureDetector(
        onTap: () {
          appRouter.pushNamed(SearchScreen.routeName);
        },
        child: const Icon(Icons.settings),
      ),
      label: "Settings",
    );
  }

  BottomNavigationBarItem tabsNavigationIcon() {
    return BottomNavigationBarItem(
      icon: GestureDetector(onTap: () {}, child: const TabsNavigationIcon()),
      label: "Tabs",
    );
  }

  BottomNavigationBarItem plusNavigationIcon() {
    return BottomNavigationBarItem(
      icon: GestureDetector(onTap: () {}, child: const PlusIconWidget()),
      label: "Add",
    );
  }

  BottomNavigationBarItem searchNavigationIcon() {
    return BottomNavigationBarItem(
      icon: GestureDetector(
          onTap: () {
            appRouter.pushNamed(SearchScreen.routeName);
          },
          child: const SearchNavigationIcon()),
      label: "Search",
    );
  }

  BottomNavigationBarItem homeNavigationIcon() {
    return const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: "Home",
    );
  }
}
