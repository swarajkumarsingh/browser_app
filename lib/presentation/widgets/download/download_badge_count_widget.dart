import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/widgets/spaces.dart';
import '../../../core/constants/color.dart';
import '../../viewModel/download_view_model.dart';

class CountBadge extends StatelessWidget {
  final WidgetRef ref;
  const CountBadge({
    super.key,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          const Text(
            "Downloaded",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const HorizontalSpace(width: 10),
          Badge.count(
            count: downloadViewModel.downloadListLength(ref),
            backgroundColor: colors.black,
            textColor: colors.white,
          )
        ],
      ),
    );
  }
}
