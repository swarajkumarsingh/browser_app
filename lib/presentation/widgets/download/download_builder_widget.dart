import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/constants.dart';
import '../../../utils/hive/hive_service.dart';
import 'download_badge_count_widget.dart';
import 'download_empty_widget.dart';
import 'download_list_tile_widget.dart';

class DownloadListenableBuilder extends StatelessWidget {
  const DownloadListenableBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(Constants.DOWNLOAD_SAVE_BOX).listenable(),
      builder: (_, box, __) {
        if (hiveService.isBoxEmpty(box)) {
          return const NoDownloads();
        }
        return Column(
          children: [
            AdaptiveDownloadTitleAndCountBadge(title: "Downloaded", length: box.values.length),
            DownloadScreenListTile(box: box)
          ],
        );
      },
    );
  }
}
