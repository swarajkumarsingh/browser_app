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
  final bool showTabController;
  final bool wantKeepAlive;
  static const String routeName = '/webview-screen';
  const WebviewScreen({
    super.key,
    required this.url,
    this.query = "",
    this.wantKeepAlive = false,
    this.showTabController = true,
  });

  @override
  ConsumerState<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends ConsumerState<WebviewScreen>
    with AutomaticKeepAliveClientMixin<WebviewScreen> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      await webviewViewModel.init(
        context: context,
        ref: ref,
        url: widget.url,
        query: widget.query,
        mounted: mounted,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final controller = ref.watch(webviewControllerProvider);

    return WillPopScope(
      onWillPop: () async => webviewViewModel.onWillPop(controller),
      child: scaffold(),
    );
  }

  Scaffold scaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: body(),
      bottomNavigationBar:
          widget.showTabController ? bottomNavigationBar() : null,
    );
  }

  Stack body() {
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

  AppBar appBar() {
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
        IconButton(
          icon: const Icon(Icons.more_vert_outlined),
          onPressed: () {},
          color: colors.black,
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
        leftNavigationIcon(),
        rightNavigationIcon(),
        playNavigationIcon(),
        tabsNavigationIcon(),
        settingsNavigationBar(),
      ],
    );
  }

  BottomNavigationBarItem leftNavigationIcon() {
    final controller = ref.watch(webviewControllerProvider);

    return BottomNavigationBarItem(
      icon: LeftIconWidget(controller: controller),
      label: "Back",
    );
  }

  BottomNavigationBarItem rightNavigationIcon() {
    final controller = ref.watch(webviewControllerProvider);

    return BottomNavigationBarItem(
      icon: RightIconWidget(controller: controller),
      label: "Forward",
    );
  }

  BottomNavigationBarItem playNavigationIcon() {
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
            onTap: () {},
          ),
        ],
      ),
      label: "Settings",
    );
  }
}
