import 'package:browser_app/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: Hive.box(Constants.DARK_MODE_BOX).listenable(),
              builder: (context, box, widget) {
                final darkMode =
                    box.get(Constants.DARK_MODE_BOX, defaultValue: false);
                return Switch(
                  value: darkMode,
                  onChanged: (val) {
                    box.put(Constants.DARK_MODE_BOX, !darkMode);
                  },
                );
              },
            ),
            const Text("Made in 🇮🇳"),
          ],
        ),
      ),
    );
  }
}
