// ignore_for_file: public_member_api_docs, depend_on_referenced_packages, use_build_context_synchronously, unawaited_futures, unused_local_variable, prefer_final_locals

import 'dart:isolate';
import 'dart:ui';

import 'package:browser_app/core/common/snackbar/show_snackbar.dart';
import 'package:browser_app/core/constants/constants.dart';
import 'package:browser_app/utils/browser/browser_utils.dart';
import 'package:browser_app/utils/download/downloader_constants.dart';
import 'package:browser_app/utils/preferences/preferences_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../core/common/widgets/toast.dart';
import '../../../core/constants/color.dart';
import '../../../core/dio/api.dart';
import '../../../core/event_tracker/event_tracker.dart';
import '../../../utils/download/downloader.dart';
import '../../widgets/home/home_navigation_icons.dart';
import '../../widgets/search/search_navigation_icons.dart';
import '../../widgets/webview/download_dialog.dart';
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

  WebViewController? _controller;
  late TextEditingController textController;
  final locationController = TextEditingController();

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    try {
      IsolateNameServer.registerPortWithName(
          _port.sendPort, 'downloader_send_port');
      _port.listen((dynamic data) {
        String id = data[0];
        DownloadTaskStatus status = DownloadTaskStatus.fromInt(data[1]);
        int progress = data[2];

        logger.success(status);
        logger.success(progress);

        if (progress == 100 || status == DownloadTaskStatus.complete) {
          showToast("File downloaded successfully");
          setState(() {});
          return;
        }
        if (status == DownloadTaskStatus.failed) {
          showToast("File downloading failed");
          setState(() {});
          return;
        }
        if (status == DownloadTaskStatus.paused) {
          showToast("File downloading paused");
          setState(() {});
          return;
        }
        if (status == DownloadTaskStatus.undefined) {
          showToast("Downloaded file is unknown/corrupted");
          setState(() {});
          return;
        }
        if (status == DownloadTaskStatus.canceled) {
          showToast("File downloading canceled");
          setState(() {});
          return;
        }
      });

      FlutterDownloader.registerCallback(downloadCallback);
    } catch (e) {
      rethrow;
    }
    _init();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');

    send!.send([id, status, progress]);
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
            showSnackBar("Something went wrong");
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (await browserUtils.isDownloadRequest(request.url)) {
              final imageData = await Api().head(request.url);
              final type = imageData.headers[Headers.contentTypeHeader]![0]
                  .replaceAll("image/", "");
              final size = (int.parse(
                          imageData.headers[Headers.contentLengthHeader]![0]) /
                      1048576)
                  .toStringAsExponential(2);

              logger.success(size);

              showDownloadDialog(
                context: context,
                fileType: type,
                storageLocation: await downloaderConstants.getDownloadDir(),
                fileSize: size,
                function: () async {
                  try {
                    final res = await downloader.downloadFile(
                      url: request.url,
                      imageContentType: type,
                      imageSize: size,
                      savedDir: await downloaderConstants.prepareSaveDir(),
                      fileName: locationController.text,
                    );

                    showToast(res.message);
                    if (mounted) appRouter.pop();
                    return;
                  } catch (e) {
                    logger.error(e);
                    rethrow;
                  }
                },
                controller: locationController,
              );
            }

            await preferenceUtils.remove(
                key: Constants.PREF_WEBVIEW_MAX_RE_TRIES);
            return NavigationDecision.prevent;
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

    await eventTracker.screen("webview-screen", {
      "url": widget.url,
      "prompt": widget.prompt,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomNavigationBar(),
      appBar: webviewScreenAppBar(),
      body: webviewScreenBody(),
    );
  }

  Stack webviewScreenBody() {
    return Stack(
      children: [
       _controller != null ? WebViewWidget(controller: _controller!) :  WebviewLoader(
            bottomNavigationBarHeight: MediaQuery.of(context).padding.bottom,
          ),
        if (_isLoading)
          WebviewLoader(
            bottomNavigationBarHeight: MediaQuery.of(context).padding.bottom,
          ),
      ],
    );
  }

  AppBar webviewScreenAppBar() {
    return AppBar(
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
