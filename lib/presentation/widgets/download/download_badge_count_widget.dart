import 'package:flutter/material.dart';

import '../../../core/common/widgets/spaces.dart';
import '../../../core/constants/color.dart';

class AdaptiveDownloadTitleAndCountBadge extends StatelessWidget {
  final String title;
  final int length;
  const AdaptiveDownloadTitleAndCountBadge({
    super.key,
    required this.title,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const HorizontalSpace(width: 10),
          Badge.count(
            count: length,
            backgroundColor: colors.black,
            textColor: colors.white,
          ),
        ],
      ),
    );
  }
}
