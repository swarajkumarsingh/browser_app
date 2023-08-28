import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';

class A extends StatelessWidget {
  const A({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                appRouter.push(const A());
              },
              icon: const Icon(Icons.abc_rounded)),
        ],
      ),
      body: SafeArea(
          child: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse("https://google.com/"),
        ),
        onDownloadStart: (controller, url) {
          logger.success("string");
        },
        onDownloadStartRequest: (controller, downloadStartRequest) {
          logger.success("downloading");
        },
      )),
    );
  }
}
