import 'package:flutter/material.dart';

import '../../../core/constants/assets.dart';
import '../../../core/common/widgets/spaces.dart';
import '../../../data/local/home_data_provider.dart';
import '../../widgets/home/home_news_feed_widget.dart';
import '../../widgets/home/home_quick_links_wrap_widget.dart';
import '../../widgets/home/home_search_textfield.dart';

class HomScreen extends StatelessWidget {
  const HomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            /// [App Bar]
            SliverAppBar(
              floating: true,
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(Assets.fullLogo),
                ),
              ),
              title: const Text(
                "Browser App",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// [Search Textfield]
                const HomeSearchTextField(),

                /// [Quick links]
                const HomeQuickLinkWrapWidget(),

                // Spacing
                const VerticalSpace(height: 30),

                /// [News widget]
                ...fakeNewsData.map(
                  (e) => NewsWidget(
                    image: e.image,
                    description: e.description,
                    redirectUrl: e.redirectUrl,
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
