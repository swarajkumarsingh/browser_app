import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/constants.dart';
import '../../widgets/settings/settings_download_screen_list_tile_widget.dart';
import '../../widgets/settings/settings_history_screen_list_tile_widget.dart';
import '../../widgets/settings/settings_made_in_india_title.dart';
import '../../widgets/settings/settings_news_screen_list_tile_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: body(),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text("Settings"),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  SingleChildScrollView body() {
    return const SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            DarkModeSwitchButtonWidget(),
            SettingsHistoryScreenListTile(),
            SettingsDownloadScreenListTile(),
            SettingsNewsScreenListTile(),
            MadeInIndiaTitle(),
          ],
        ),
      ),
    );
  }
}


class DarkModeSwitchButtonWidget extends StatelessWidget {
  const DarkModeSwitchButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(Constants.DARK_MODE_BOX).listenable(),
      builder: (_, box, __) {
        final darkMode = box.get(Constants.DARK_MODE_BOX, defaultValue: false);
        return ListTile(
          title: const Text("Dark Mode"),
          trailing: Switch(
            value: darkMode,
            onChanged: (val) {
              box.put(Constants.DARK_MODE_BOX, !darkMode);
            },
          ),
        );
      },
    );
  }
}
