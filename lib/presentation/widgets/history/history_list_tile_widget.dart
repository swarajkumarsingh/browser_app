import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/models/history_model.dart';
import '../../../utils/functions/functions.dart';
import '../../viewModel/history_screen_view_model.dart';

class HistoryListTileWidget extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      // onTap: () => historyViewModel.navigateToWebviewScreen(ref,homeModel.url),
      onTap: () {
        functions.navigateToWebviewScreen(
          ref: ref,
          url: homeModel.url,
          mounted: true,
        );
      },
      leading: const Icon(FontAwesomeIcons.globe),
      title: Text(
        homeModel.prompt == "" ? homeModel.url : homeModel.prompt,
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
                historyViewModel.navigateToWebviewScreen(ref, context, homeModel.url),
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
