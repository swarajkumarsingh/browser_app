import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/constants.dart';
import '../../../data/db/webview_db.dart';
import '../../../data/provider/state_providers.dart';
import '../../../domain/models/webview_model.dart';
import '../../../utils/browser/browser_utils.dart';
import '../../../utils/functions/functions.dart';
import '../../../utils/text_utils.dart';
import '../../viewModel/tabs_view_model.dart';
import '../../widgets/tabs/tab_widget.dart';

class TabsScreen extends ConsumerWidget {
  const TabsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: appBar(ref, context),
      body: body(ref, context),
    );
  }

  SingleChildScrollView body(WidgetRef ref, BuildContext context) {
    final tabList = ref.watch(tabsListProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Center(
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              ...tabList.map(
                (WebViewModel tab) => TabWidget(
                  image: tab.screenshot!,
                  onCloseButtonClicked: () {
                    // delete tab
                    tabViewModel.deleteTab(ref, tab.id);
                  },
                  onTap: () async {
                    var prompt = tab.url;
                    // Url
                    if (textUtils.isValidUrl(prompt)) {
                      final url = browserUtils.addHttpToDomain(prompt);
                      await functions.navigateToWebviewScreen(
                        ref: ref,
                        url: url,
                        mounted: true,
                      );
                      return;
                    }

                    // Query
                    prompt = textUtils.replaceSpaces(prompt);
                    final url = browserUtils.addQueryToGoogle(prompt);
                    await functions.navigateToWebviewScreen(
                      ref: ref,
                      url: url,
                      mounted: true,
                    );
                    // Last viewed tab index
                  },
                  title: tab.title,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(WidgetRef ref, BuildContext context) {
    return AppBar(
      title: const Text('New Tab'),
      scrolledUnderElevation: 0,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          const title = "Google";
          tabViewModel.addTab(
              ref: ref,
              url: googleUrl,
              title: title,
              screenshot: webviewDB.getHomeScreenImageBytes());
        },
        icon: const Icon(Icons.add),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
      ],
    );
  }
}
