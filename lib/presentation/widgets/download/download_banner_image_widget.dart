import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';


class DownloadScreenBannerImage extends StatelessWidget {
  const DownloadScreenBannerImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: Constants.downloadImageUrl,
      height: 200,
      width: double.infinity,
      fit: BoxFit.fitWidth,
    );
  }
}
