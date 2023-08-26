import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../viewModel/history_view_model.dart';
import '../../../domain/models/history_model.dart';

class HistoryListTileWidget extends StatelessWidget {
  final Box<dynamic> box;
  final int boxKey;
  const HistoryListTileWidget({
    super.key,
    required this.homeModel,
    required this.box,
    required this.boxKey,
  });

  final HistoryModel homeModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => historyViewModel.navigateToWebviewScreen(homeModel.url),
      leading: const Icon(FontAwesomeIcons.globe),
      title: Text(
        homeModel.prompt,
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        homeModel.url,
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: PopupMenuButton(
        elevation: 1,
        surfaceTintColor: Colors.grey,
        itemBuilder: (context) => [
          PopupMenuItem(
            child: const Text("Open"),
            onTap: () =>
                historyViewModel.navigateToWebviewScreen(homeModel.url),
          ),
          PopupMenuItem(
            child: const Text("Delete"),
            onTap: () async => historyViewModel.deleteHistory(boxKey),
          ),
          PopupMenuItem(
            child: const Text("Share"),
            onTap: () async => historyViewModel.shareUrl(homeModel.url),
          ),
        ],
      ),
    );
  }
}
