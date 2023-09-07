import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewReloadIconWidget extends StatelessWidget {
  const WebviewReloadIconWidget({
    super.key,
    required this.controller,
  });

  final WebViewController? controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await controller!.reload();
      },
      icon: const Icon(Icons.refresh_outlined),
    );
  }
}
