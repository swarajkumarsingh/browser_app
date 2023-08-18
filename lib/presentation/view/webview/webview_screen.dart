// ignore_for_file: public_member_api_docs, depend_on_referenced_packages, use_build_context_synchronously

import 'package:browser_app/core/constants/constants.dart';
import 'package:browser_app/utils/browser/browser_utils.dart';
import 'package:browser_app/utils/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../core/common/widgets/alertdialog_widget.dart';
import '../../../core/constants/color.dart';
import '../../widgets/home/home_navigation_icons.dart';
import '../../widgets/search/search_navigation_icons.dart';
import '../../widgets/webview/webview_loader.dart';
import '../home/home_screen.dart';
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
  bool _showModal = false;

  WebViewController? _controller;
  late TextEditingController textController;
  final locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
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
          onPageStarted: (String url) async {
            logger.info('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            logger.info('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            logger.error('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) async {
            int tries = preferenceUtils.getInt(
                key: Constants.PREF_WEBVIEW_MAX_RE_TRIES, defaultValue: 0);
            tries = tries + 1;

            if (tries >= 2) {
              if (await browserUtils.isDownloadRequest(request.url)) {
                logger.pink("MAX: ${request.url}");
                await Clipboard.setData(ClipboardData(text: request.url));
                showDownloadDialog(
                  context: context,
                  function: () {},
                  controller: locationController,
                );
              }

              await preferenceUtils.remove(
                  key: Constants.PREF_WEBVIEW_MAX_RE_TRIES);
              return NavigationDecision.prevent;
            }
            await preferenceUtils.setInt(
                key: Constants.PREF_WEBVIEW_MAX_RE_TRIES, value: tries);

            logger.info('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
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
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.url));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomNavigationBar(),
      appBar: AppBar(
        leadingWidth: 30,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            appRouter.push(const HomeScreen());
          },
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
            onChanged: (value) {},
            // readOnly: true,
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
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller!),
          if (_showModal)
            GestureDetector(
              onTap: () {},
              child: Container(
                color: const Color.fromRGBO(
                    0, 0, 0, 0.5), // Semi-transparent background
                child: Center(
                  child: Container(
                    width: 200,
                    height: 150,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('This is a modal'),
                        ElevatedButton(
                          onPressed: () => setState(() {
                            _showModal = false;
                          }),
                          child: const Text('Close Modal'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (_isLoading) const WebviewLoader(),
        ],
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
