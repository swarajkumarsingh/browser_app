import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/constants.dart';
import '../../../utils/hive/hive_service.dart';
import 'download_badge_count_widget.dart';
import 'downloading_list_tile_widget.dart';

class DownloadingListenableBuilder extends StatelessWidget {
  const DownloadingListenableBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(Constants.DOWNLOADING_SAVE_BOX).listenable(),
      builder: (_, box, __) {
        if (hiveService.isBoxEmpty(box)) {
          return const SizedBox();
        }
        return Column(
          children: [
            AdaptiveDownloadTitleAndCountBadge(title: "Downloading", length: box.values.length),
            DownloadingScreenListTile(box: box),
            const Divider(),
          ],
        );
      },
    );
  }
}
