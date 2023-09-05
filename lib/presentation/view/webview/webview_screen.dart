import 'package:browser_app/presentation/view/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/constants/color.dart';
import '../../../data/provider/state_providers.dart';
import '../../viewModel/webview_view_model.dart';
import '../../widgets/home/home_navigation_icons.dart';
import '../../widgets/search/search_navigation_icons.dart';
import '../../widgets/webview/webview_loader.dart';
import '../download/download_screen.dart';
import '../history/history_screen.dart';
import '../search/search_screen_webview.dart';

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
    final controller = ref.watch(webviewControllerProvider);
    return WillPopScope(
      onWillPop: () async => webviewViewModel.onWillPop(controller),
      child: scaffold(ref),
    );
  }

  Scaffold scaffold(WidgetRef ref) {
    return Scaffold(
      appBar: appBar(ref),
      body: body(ref),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
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
          leftNavigationIcon(ref),
          rightNavigationIcon(ref),
          playNavigationIcon(ref),
          tabsNavigationIcon(),
          settingsNavigationBar(),
        ],
      ),
    );
  }

  Stack body(WidgetRef ref) {
    final webviewScreenLoading = ref.watch(webviewScreenLoadingProvider);
    final controller = ref.watch(webviewControllerProvider);

    return Stack(
      children: [
        controller != null
            ? WebViewWidget(controller: controller)
            : const WebviewLoader(),
        if (webviewScreenLoading) const WebviewLoader(),
      ],
    );
  }

  AppBar appBar(WidgetRef ref) {
    final searchTextController = ref.watch(webviewSearchTextControllerProvider);
    final controller = ref.watch(webviewControllerProvider);

    return AppBar(
      leadingWidth: 30,
      elevation: 0,
      leading: IconButton(
        onPressed: webviewViewModel.navigateToHomeScreen,
        icon: const Icon(
          Icons.home_outlined,
          color: Colors.black,
        ),
      ),
      actions: [
        PopupMenuButton(
          elevation: 1,
          icon: const Icon(Icons.settings),
          surfaceTintColor: Colors.grey,
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text("History"),
              onTap: () => appRouter.push(const HistoryScreen()),
            ),
            PopupMenuItem(
              child: const Text("Downloads"),
              onTap: () => appRouter.push(const DownloadScreen()),
            ),
            PopupMenuItem(
              child: const Text("Settings"),
              onTap: () => appRouter.push(const SettingsScreen()),
            ),
          ],
        ),
      ],
      title: GestureDetector(
        onTap: () {
          appRouter.push(
            SearchScreenWebview(
              prompt: widget.query == ""
                  ? Uri.parse(widget.url).host
                  : widget.query,
              url: widget.url,
            ),
          );
        },
        child: TextField(
          onChanged: (value) {
            // TODO: Implement google search
          },
          enabled: false,
          canRequestFocus: false,
          keyboardType: TextInputType.none,
          controller: searchTextController,
          decoration: InputDecoration(
            filled: true,
            hintMaxLines: 1,
            fillColor: colors.homeTextFieldColor,
            hintText: 'Search or type Web address',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
            prefixIcon: const Icon(Icons.privacy_tip_outlined),
            suffixIcon: InkWell(
              onTap: () async {
                await controller!.reload();
              },
              child: const Icon(Icons.refresh_outlined),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBar bottomNavigationBar(WidgetRef ref) {
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
    final controller = ref.watch(webviewControllerProvider);

    return BottomNavigationBarItem(
      icon: RightIconWidget(controller: controller),
      label: "Forward",
    );
  }

  BottomNavigationBarItem playNavigationIcon(WidgetRef ref) {
    final controller = ref.watch(webviewControllerProvider);

    return BottomNavigationBarItem(
      icon: PlayIconWidget(controller: controller),
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
    return BottomNavigationBarItem(
      icon: PopupMenuButton(
        elevation: 1,
        icon: const Icon(Icons.settings),
        surfaceTintColor: Colors.grey,
        itemBuilder: (context) => [
          PopupMenuItem(
            child: const Text("History"),
            onTap: () => appRouter.push(const HistoryScreen()),
          ),
          PopupMenuItem(
            child: const Text("Downloads"),
            onTap: () => appRouter.push(const DownloadScreen()),
          ),
          PopupMenuItem(
            child: const Text("Settings"),
            onTap: () => appRouter.push(const SettingsScreen()),
          ),
        ],
      ),
      label: "Settings",
    );
  }
}
