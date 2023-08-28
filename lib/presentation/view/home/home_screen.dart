import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import '../../../core/common/widgets/spaces.dart';
import '../../../core/constants/assets.dart';
import '../../../data/db/webview_db.dart';
import '../../../data/local/home_data_provider.dart';
import '../../viewModel/home_view_model.dart';
import '../../widgets/home/home_navigation_icons.dart';
import '../../widgets/home/home_news_feed_widget.dart';
import '../../widgets/home/home_quick_links_wrap_widget.dart';
import '../../widgets/home/home_search_textfield.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  ScreenshotController screenshotController = ScreenshotController();

  void _init() async {
    await homeViewModel.logScreen();
    await webviewDB.addHomeScreenScreenShotBytes(screenshotController);
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: appBar(),
        body: body(),
        bottomNavigationBar: bottomNavigationBar(),
      ),
    );
  }

  SingleChildScrollView body() {
    return SingleChildScrollView(
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
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset(assets.fullLogo),
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
    return const BottomNavigationBarItem(
      icon: SettingsIconWidget(),
      label: "Settings",
    );
  }

  BottomNavigationBarItem tabsNavigationIcon() {
    return BottomNavigationBarItem(
      icon: TabsNavigationIcon(ref: ref),
      label: "Tabs",
    );
  }

  BottomNavigationBarItem plusNavigationIcon() {
    return const BottomNavigationBarItem(
      icon: PlusIconWidget(),
      label: "Add",
    );
  }

  BottomNavigationBarItem searchNavigationIcon() {
    return const BottomNavigationBarItem(
      icon: SearchNavigationIcon(),
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
