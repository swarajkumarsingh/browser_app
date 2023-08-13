import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/common/widgets/spaces.dart';

class SubSearchScreenQuickLinks extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
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
    );
  }
}
