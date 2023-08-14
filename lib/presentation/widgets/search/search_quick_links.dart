import 'package:flutter/material.dart';

import 'package:browser_app/presentation/widgets/search/search_sub_quick_links.dart';

import '../../../core/common/widgets/spaces.dart';
import '../../../core/constants/color.dart';
import '../../../domain/models/search/search_quick_links.dart';

class SearchScreenQuickLinks extends StatelessWidget {
  final String tag;
  final List<QuickLinks> quickLinks;
  const SearchScreenQuickLinks({
    Key? key,
    required this.tag,
    required this.quickLinks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VerticalSpace(height: 20),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 0.1,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: colors.white,
            ),
            child:
                Text(tag, style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
        ),
        const VerticalSpace(height: 20),
        Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 15,
            children: [
              ...quickLinks.map((e) => SubSearchScreenQuickLinks(
                  name: e.text, image: e.imageUrl, redirectUrl: e.redirectLink))
            ],
          ),
        )
      ],
    );
  }
}
