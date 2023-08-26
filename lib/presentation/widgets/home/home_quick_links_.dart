import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

import '../../view/webview/webview_screen.dart';

class QuickLinksWidget extends StatelessWidget {
  const QuickLinksWidget({
    Key? key,
    required this.image,
    required this.redirectUrl,
    required this.text,
  }) : super(key: key);

  final String text;
  final String image;
  final String redirectUrl;

  final double wrapIconHeight = 50.0;
  final double wrapIconWidth = 50.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        appRouter.push(WebviewScreen(url: redirectUrl));
      },
      child: Column(
        children: [
          SizedBox(
            height: wrapIconHeight,
            width: wrapIconWidth,
            child: CachedNetworkImage(
              imageUrl: image,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Text(text),
        ],
      ),
    );
  }
}
