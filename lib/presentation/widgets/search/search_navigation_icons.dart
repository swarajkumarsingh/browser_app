import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/common/snackbar/show_snackbar.dart';
import '../../../data/provider/state_providers.dart';

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
      child: Icon(
        Icons.arrow_back_ios_new_outlined,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black,
      ),
    );
  }
}

class RightIconWidget extends StatelessWidget {
  final WidgetRef ref;
  const RightIconWidget({
    super.key,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(webviewControllerProvider);

    return GestureDetector(
      onTap: () async {
        if (controller == null) {
          return;
        }

        if (!await controller.canGoForward()) {
          showSnackBar("Cannot go forward");
          return;
        }
        await controller.goForward();
      },
      child: Icon(
        Icons.arrow_forward_ios_outlined,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black,
      ),
    );
  }
}

class PlayIconWidget extends StatelessWidget {
  const PlayIconWidget({
    super.key,
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
