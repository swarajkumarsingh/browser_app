import 'package:flutter/material.dart';

import '../../widgets/home/news_tree_widget.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text("Today's News"),
    );
  }

  SingleChildScrollView body() {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// [News widget]
            NewsContainer(),
          ],
        ),
      ),
    );
  }
}
