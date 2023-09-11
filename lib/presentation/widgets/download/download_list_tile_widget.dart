import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/models/download_save_model.dart';
import '../../viewModel/download_screen_view_model.dart';

class DownloadScreenListTile extends StatelessWidget {
  final Box<dynamic> box;
  const DownloadScreenListTile({
    super.key,
    required this.box,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...box.keys.map((key) {
          final item = box.get(key);
          final model = DownloadSaveModel.fromJson(item);
          return ListTile(
            leading: const Icon(
              Icons.download_for_offline,
              size: 35,
            ),
            title: Text(model.filename,
                maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
            subtitle: Text(model.size ?? "0 MB"),
            trailing: IconButton(
              onPressed: () =>
                  downloadViewModel.deleteFile(key, model.savedPath),
              icon: const Icon(Icons.more_vert_rounded),
            ),
          );
        }),
      ],
    );
  }
}
