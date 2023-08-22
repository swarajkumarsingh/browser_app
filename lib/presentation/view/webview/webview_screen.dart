// ignore_for_file: public_member_api_docs, depend_on_referenced_packages, use_build_context_synchronously, unawaited_futures, unused_local_variable, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:browser_app/presentation/viewModel/webview/webview_view_model.dart';

import '../../../core/constants/color.dart';
import '../../../core/event_tracker/event_tracker.dart';
import '../../widgets/home/home_navigation_icons.dart';
import '../../widgets/search/search_navigation_icons.dart';
import '../../widgets/webview/webview_loader.dart';
import '../search/search_screen_webview.dart';

class WebviewScreen extends StatefulWidget {
  final String url;
  final String prompt;
  static const String routeName = '/webview-screen';
  const WebviewScreen({super.key, required this.url, this.prompt = ""});

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  bool _isLoading = false;
  WebViewController? _controller;
  late TextEditingController textController;
  final _fileNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  void _init() async {
    textController = TextEditingController(text: widget.url);

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            logger.info('WebView is loading (progress : $progress%)');
            if (progress < 70) {
              setState(() {
                _isLoading = true;
              });
              return;
            }
            setState(() {
              _isLoading = false;
            });
          },
          onPageStarted: (String url) => webviewViewModel.onPageStarted,
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            logger.info('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) async =>
              webviewViewModel.onWebResourceError,
          onNavigationRequest: (NavigationRequest request) =>
              webviewViewModel.onNavigationRequest(
            request: request,
            context: context,
            fileNameController: _fileNameController,
            mounted: mounted,
          ),
          onUrlChange: (UrlChange change) async {
            logger.info('url change to ${change.url}');

            setState(() {
              textController.text = change.url ?? textController.text;
            });
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) => webviewViewModel.onMessageReceived(context, message),
      )
      ..loadRequest(Uri.parse(widget.url));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;

    await eventTracker.screen("webview-screen", {
      "url": widget.url,
      "prompt": widget.prompt,
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => webviewViewModel.onWillPop(_controller),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: bottomNavigationBar(),
        appBar: webviewScreenAppBar(),
        body: webviewScreenBody(),
      ),
    );
  }

  Stack webviewScreenBody() {
    return Stack(
      children: [
        _controller != null
            ? WebViewWidget(controller: _controller!)
            : const WebviewLoader(),
        if (_isLoading) const WebviewLoader(),
      ],
    );
  }

  AppBar webviewScreenAppBar() {
    return AppBar(
      leadingWidth: 30,
      elevation: 0,
      leading: IconButton(
        onPressed: () => webviewViewModel.navigateToHomeScreen(),
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
              prompt: widget.prompt == ""
                  ? Uri.parse(widget.url).host
                  : widget.prompt,
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
          controller: textController,
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
                await _controller!.reload();
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
    return BottomNavigationBarItem(
      icon: LeftIconWidget(controller: _controller),
      label: "Back",
    );
  }

  BottomNavigationBarItem rightNavigationIcon() {
    return BottomNavigationBarItem(
      icon: RightIconWidget(controller: _controller),
      label: "Forward",
    );
  }

  BottomNavigationBarItem playNavigationIcon() {
    return BottomNavigationBarItem(
      icon: PlayIconWidget(controller: _controller),
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
      icon: SettingsIconWidget(),
      label: "Settings",
    );
  }
}
