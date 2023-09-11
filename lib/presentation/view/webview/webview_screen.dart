import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../data/provider/state_providers.dart';
import '../../viewModel/webview_screen_view_model.dart';
import '../../widgets/home/home_navigation_icons.dart';
import '../../widgets/home/more_options_menu_widget.dart';
import '../../widgets/search/search_navigation_icons.dart';
import '../../widgets/webview/webview_loader_widget.dart';
import '../../widgets/webview/webview_reload_icon_widget.dart';
import '../../widgets/webview/webview_text_field_widget.dart';

class WebviewScreen extends ConsumerStatefulWidget {
  final String url;
  final String query;
  final bool wantKeepAlive;
  static const String routeName = '/webview-screen';
  const WebviewScreen({
    super.key,
    this.query = "",
    required this.url,
    this.wantKeepAlive = false,
  });

  @override
  ConsumerState<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends ConsumerState<WebviewScreen>
    with AutomaticKeepAliveClientMixin<WebviewScreen> {
  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async => webviewViewModel.onWillPop(ref),
      child: scaffold(ref),
    );
  }

  Scaffold scaffold(WidgetRef ref) {
    return Scaffold(
      appBar: appBar(ref),
      body: body(ref),
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: bottomNavigationBar(ref),
    );
  }

  AppBar appBar(WidgetRef ref) {
    final controller = ref.watch(webviewControllerProvider);
    final searchTextController = ref.watch(webviewSearchTextControllerProvider);

    return AppBar(
      leadingWidth: 30,
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: IconThemeData(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black,
      ),
      leading: const WebviewHomeIconWidget(),
      actions: [
        WebviewReloadIconWidget(controller: controller),
        const MoreOptionsMenuWidget(),
      ],
      title: WebviewTextfieldWidget(
        url: widget.url,
        query: widget.query,
        searchTextController: searchTextController,
        controller: controller,
      ),
    );
  }

  Stack body(WidgetRef ref) {
    final loading = ref.watch(webviewScreenLoadingProvider);
    final controller = ref.watch(webviewControllerProvider);

    return Stack(
      children: [
        controller != null
            ? WebViewWidget(controller: controller)
            : const WebviewLoader(),
        if (loading) const WebviewLoader(),
      ],
    );
  }

  BottomNavigationBar bottomNavigationBar(WidgetRef ref) {
    return BottomNavigationBar(
      iconSize: 25,
      elevation: 0,
      showSelectedLabels: false,
      useLegacyColorScheme: true,
      showUnselectedLabels: false,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).primaryColor,
      items: [
        leftNavigationIcon(ref),
        rightNavigationIcon(ref),
        playNavigationIcon(ref),
        tabsNavigationIcon(),
        settingsNavigationBar(),
      ],
    );
  }

  BottomNavigationBarItem leftNavigationIcon(WidgetRef ref) {
    final controller = ref.watch(webviewControllerProvider);

    return BottomNavigationBarItem(
      icon: LeftIconWidget(controller: controller),
      label: "Back",
    );
  }

  BottomNavigationBarItem rightNavigationIcon(WidgetRef ref) {
    return BottomNavigationBarItem(
      icon: RightIconWidget(ref: ref),
      label: "Forward",
    );
  }

  BottomNavigationBarItem playNavigationIcon(WidgetRef ref) {
    return const BottomNavigationBarItem(
      icon: PlayIconWidget(),
      label: "Play",
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
      label: "Settings",
    );
  }
}

class WebviewHomeIconWidget extends StatelessWidget {
  const WebviewHomeIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: webviewViewModel.navigateToHomeScreen,
      icon: const Icon(Icons.home_outlined),
    );
  }
}
