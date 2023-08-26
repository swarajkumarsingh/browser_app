import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/common/snackbar/show_snackbar.dart';

class LeftIconWidget extends StatelessWidget {
  final WebViewController? controller;
  const LeftIconWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (controller == null) {
          return;
        }

        if (!await controller!.canGoBack()) {
          showSnackBar("Cannot go back");
          return;
        }
        await controller!.goBack();
      },
      child: const Icon(Icons.arrow_back_ios_new_outlined),
    );
  }
}

class RightIconWidget extends StatelessWidget {
  final WebViewController? controller;
  const RightIconWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (controller == null) {
          return;
        }

        if (!await controller!.canGoForward()) {
          showSnackBar("Cannot go forward");
          return;
        }
        await controller!.goForward();
      },
      child: const Icon(Icons.arrow_forward_ios_outlined),
    );
  }
}

class PlayIconWidget extends StatelessWidget {
  final WebViewController? controller;
  const PlayIconWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: const Icon(
        Icons.play_circle_filled_outlined,
        color: Colors.blue,
      ),
    );
  }
}
