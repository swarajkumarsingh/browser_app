import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/models/downloading_model.dart';
import '../../../utils/hive/hive_service.dart';
import '../../viewModel/download_view_model.dart';
import '../../widgets/download/download_badge_count_widget.dart';
import '../../widgets/download/download_banner_image_widget.dart';
import '../../widgets/download/download_builder_widget.dart';
import '../../widgets/download/download_leading_icon_button.dart';

class DownloadScreen extends ConsumerStatefulWidget {
  const DownloadScreen({super.key});

  @override
  ConsumerState<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends ConsumerState<DownloadScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  String taskID = "";

  void _init() async {
    await downloadViewModel.logScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color.fromARGB(255, 0, 24, 48),
        leading: const DownloadScreenLeadingIconButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DownloadScreenBannerImage(),
            CountBadge(ref: ref),
            const DownloadingListenableBuilder(),
            const Divider(),
            const DownloadListenableBuilder(),
          ],
        ),
      ),
    );
  }
}

class DownloadingListenableBuilder extends StatelessWidget {
  const DownloadingListenableBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(Constants.DOWNLOADING_SAVE_BOX).listenable(),
      builder: (context, box, widget) {
        if (hiveService.isBoxEmpty(box)) {
          return const SizedBox();
        }
        return DownloadingScreenListTile(box: box);
      },
    );
  }
}

class DownloadingScreenListTile extends StatelessWidget {
  final Box<dynamic> box;
  const DownloadingScreenListTile({
    super.key,
    required this.box,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...box.keys.map((key) { 
          final item = box.get(key);
          final model = DownloadingModel.fromJson(item);
          return ListTile(
            leading: const Icon(
              Icons.download_for_offline,
              size: 35,
            ),
            title: Text(model.filename,
                maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
            subtitle: Text(model.progress.toString()),
            trailing: const CircularProgressIndicator(),
          );
        }),
      ],
    );
  }
}
