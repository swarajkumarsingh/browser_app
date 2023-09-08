import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

import '../../view/news/news_screen.dart';

class SettingsNewsScreenListTile extends StatelessWidget {
  const SettingsNewsScreenListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        appRouter.push(const NewsScreen());
      },
      title: const Text("News Screen"),
    );
  }
}
