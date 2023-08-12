import 'package:flutter/material.dart';

import '../../../data/local/fav_links.dart';
import 'home_quick_links_.dart';


class HomeQuickLinkWrapWidget extends StatelessWidget {
  const HomeQuickLinkWrapWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 15,
      children: [
        ...fakeQuickLinks.map(
          (e) {
            return QuickLinksWidget(
              image: e.imageUrl,
              text: e.text,
              redirectUrl: e.redirectLink,
            );
          },
        ),
      ],
    );
  }
}
