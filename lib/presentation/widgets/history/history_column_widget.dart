import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/models/history_model.dart';
import 'history_list_tile_widget.dart';

class HistoryColumnWidget extends StatelessWidget {
  final Box<dynamic> box;
  const HistoryColumnWidget({
    super.key,
    required this.box,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...box.keys.map(
          (boxKey) {
            final item = box.get(boxKey);
            final homeModel = HistoryModel.fromJson(item);
            return HistoryListTileWidget(box: box, boxKey: boxKey, homeModel: homeModel);
          },
        ),
      ],
    );
  }
}
