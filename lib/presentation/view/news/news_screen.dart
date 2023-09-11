import '../../viewModel/news_screen_view_model.dart';
import 'package:flutter/material.dart';

import '../../widgets/home/news_container.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await newsViewModel.logScreen();
  }

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
