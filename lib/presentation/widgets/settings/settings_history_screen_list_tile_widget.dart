import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

import '../../view/history/history_screen.dart';

class SettingsHistoryScreenListTile extends StatelessWidget {
  const SettingsHistoryScreenListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          appRouter.push(const HistoryScreen());
        },
        title: const Text("History Screen"));
  }
}
