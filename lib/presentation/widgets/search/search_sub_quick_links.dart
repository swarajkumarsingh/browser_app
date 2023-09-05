import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/widgets/spaces.dart';
import '../../../utils/functions/functions.dart';

class SubSearchScreenQuickLinks extends ConsumerWidget {
  final String name;
  final String image;
  final String redirectUrl;
  const SubSearchScreenQuickLinks({
    Key? key,
    required this.image,
    required this.name,
    required this.redirectUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        functions.navigateToWebviewScreen(ref: ref, url: redirectUrl, mounted: true);
      },
      child: SizedBox(
        height: 80,
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: CachedNetworkImage(
                imageUrl: image,
              ),
            ),
            const VerticalSpace(height: 20),
            Text(name),
          ],
        ),
      ),
    );
  }
}
