import '../settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

import '../../viewModel/download_screen_view_model.dart';
import '../../widgets/download/download_builder_widget.dart';
import '../../widgets/download/downloading_builder_widget.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await downloadViewModel.logScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: body(),
    );
  }

  SingleChildScrollView body() {
    return const SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DownloadingListenableBuilder(),
          DownloadListenableBuilder(),
        ],
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leadingWidth: 0,
      leading: const SizedBox(),
      scrolledUnderElevation: 0,
      title: const Text("Download"),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        IconButton(onPressed: () => appRouter.pop(), icon: const Icon(Icons.close)),
        IconButton(onPressed: () => appRouter.push(const SettingsScreen()), icon: const Icon(Icons.settings)),
      ],
    );
  }
}
