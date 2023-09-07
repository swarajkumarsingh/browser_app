import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

import '../../view/download/download_screen.dart';

class SettingsDownloadScreenListTile extends StatelessWidget {
  const SettingsDownloadScreenListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        appRouter.push(const DownloadScreen());
      },
      title: const Text("Downloads Screen"),
    );
  }
}
