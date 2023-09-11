import 'package:flutter/material.dart';

import '../../../data/local/fav_links.dart';
import 'home_quick_links_.dart';

class HomeQuickLinkWrapWidget extends StatefulWidget {
  const HomeQuickLinkWrapWidget({
    super.key,
  });

  @override
  State<HomeQuickLinkWrapWidget> createState() => _HomeQuickLinkWrapWidgetState();
}

class _HomeQuickLinkWrapWidgetState extends State<HomeQuickLinkWrapWidget>  {
  @override
  Widget build(BuildContext context) {

    return Wrap(
      spacing: 18,
      runSpacing: 15,
      children: [
        ...fakeFavoriteLinks.map(
          (e) {
            return SingleChildScrollView(
              child: QuickLinksWidget(
                image: e.imageUrl,
                text: e.text,
                redirectUrl: e.redirectLink,
              ),
            );
          },
        ),
      ],
    );
  }
}
