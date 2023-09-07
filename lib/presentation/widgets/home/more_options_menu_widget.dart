import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

import '../../view/download/download_screen.dart';
import '../../view/history/history_screen.dart';
import '../../view/settings/settings_screen.dart';

class MoreOptionsMenuWidget extends StatelessWidget {
  const MoreOptionsMenuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 1,
      surfaceTintColor: Colors.grey,
      itemBuilder: (context) => [
        PopupMenuItem(
            child: const Text("History"),
            onTap: () => appRouter.push(const HistoryScreen())),
        PopupMenuItem(
          child: const Text("Downloads"),
          onTap: () => appRouter.push(const DownloadScreen()),
        ),
        PopupMenuItem(
          child: const Text("Settings"),
          onTap: () => appRouter.push(const SettingsScreen()),
        ),
      ],
    );
  }
}
