import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({
    Key? key,
    required this.newsImage,
    required this.newsTitle,
  }) : super(key: key);

  final String newsImage;
  final String newsTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: newsImage,
              height: 200,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              newsTitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
