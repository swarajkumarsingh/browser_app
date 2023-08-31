import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/models/downloading_model.dart';

class DownloadingScreenListTile extends StatelessWidget {
  final Box<dynamic> box;
  const DownloadingScreenListTile({
    super.key,
    required this.box,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...box.keys.map((key) {
          final item = box.get(key);
          final model = DownloadingModel.fromJson(item);
          return ListTile(
            leading: const Icon(
              Icons.download_for_offline,
              size: 35,
            ),
            title: Text(model.filename,
                maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
            subtitle: const Text("10MB"),
            trailing: CircularProgressIndicator(value: model.progress / 100),
          );
        }),
      ],
    );
  }
}
