import 'package:flutter/material.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import '../../../core/common/widgets/spaces.dart';
import '../../../core/constants/constants.dart';
import '../../../data/db/webview_db.dart';
import '../../../data/local/home_data_provider.dart';
import '../../viewModel/home_view_model.dart';
import '../../viewModel/webview_view_model.dart';
import '../../widgets/home/home_navigation_icons.dart';
import '../../widgets/home/home_news_feed_widget.dart';
import '../../widgets/home/home_quick_links_wrap_widget.dart';
import '../../widgets/home/home_search_textfield.dart';
import '../../widgets/home/more_options_menu_widget.dart';
import '../../widgets/home/responsive_title_widget.dart';

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
    logger.success(const String.fromEnvironment("SALT"));
    await Future(() async {
      await webviewViewModel.init(
          ref: ref, url: googleUrl, query: "", mounted: mounted);
    });
    await webviewDB.addHomeScreenScreenShotBytes(screenshotController);
    await homeViewModel.logScreen();
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
      actions: const [
        MoreOptionsMenuWidget(),
      ],
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      title: const ResponsiveTitleWidget(),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      elevation: 0,
      iconSize: 25,
      showSelectedLabels: false,
      useLegacyColorScheme: true,
      showUnselectedLabels: false,
      backgroundColor: Theme.of(context).primaryColor,
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

  BottomNavigationBarItem searchNavigationIcon() {
    return const BottomNavigationBarItem(
      icon: SearchNavigationIcon(),
      label: "Search",
    );
  }

  BottomNavigationBarItem homeNavigationIcon() {
    return const BottomNavigationBarItem(
      icon: HomeNavigationIcon(),
      label: "Home",
    );
  }

  BottomNavigationBarItem plusNavigationIcon() {
    return const BottomNavigationBarItem(
      icon: PlusNavigationIcon(),
      label: "Add",
    );
  }

  BottomNavigationBarItem tabsNavigationIcon() {
    return const BottomNavigationBarItem(
      icon: TabsNavigationIcon(),
      label: "Tabs",
    );
  }

  BottomNavigationBarItem settingsNavigationBar() {
    return const BottomNavigationBarItem(
      icon: SettingsNavigationIcon(),
      label: "Tabs",
    );
  }
}
