import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';



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

  final double wrapIconHeight = 60.0;
  final double wrapIconWidth = 60.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: wrapIconHeight,
          width: wrapIconWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
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
        ),
        Text(text),
      ],
    );
  }
}
