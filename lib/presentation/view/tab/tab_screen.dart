import '../../../data/provider/state_providers.dart';
import '../../../domain/models/webview_model.dart';
import '../webview/webview_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabsScreen extends ConsumerWidget {
  const TabsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabList = ref.watch(tabsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Tab'),
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                ...tabList.map(
                  (WebViewModel tab) => Tab(
                    image: tab.screenshot!,
                    onCloseButtonClicked: () {
                      // delete tab
                    },
                    onTap: () {
                      appRouter.pushAndRemoveUntil(WebviewScreen(url: tab.url, wantKeepAlive: true));
                      // Last viewed tab index
                    },
                    title: tab.title,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Tab extends StatelessWidget {
  final String title;
  final Uint8List image;
  final VoidCallback onTap;
  final VoidCallback onCloseButtonClicked;

  const Tab({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
    required this.onCloseButtonClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 230,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        width: MediaQuery.of(context).size.width * 0.42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
          border: Border.all(
            color: Colors.grey[100]!,
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              style: ListTileStyle.list,
              contentPadding: const EdgeInsets.all(0),
              minVerticalPadding: 0,
              horizontalTitleGap: 8,
              minLeadingWidth: 0,
              leading: const Icon(FontAwesomeIcons.globe),
              title: Text(
                title,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: onCloseButtonClicked,
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
