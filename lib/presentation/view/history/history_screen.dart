import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/constants.dart';
import '../../../utils/hive/hive_service.dart';
import '../../viewModel/history_view_model.dart';
import '../../widgets/history/history_column_widget.dart';
import '../../widgets/history/no_history_widget.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = '/history-screen';
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await historyViewModel.logScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: historyAppBar(),
      body: historyBody(),
    );
  }

  AppBar historyAppBar() {
    return AppBar(
      title: const Text("History"),
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        PopupMenuButton(
          elevation: 1,
          surfaceTintColor: Colors.grey,
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text("Delete All"),
              onTap: () async => historyViewModel.deleteAll(),
            ),
            PopupMenuItem(
              child: const Text("Delete Today's History"),
              onTap: () async => historyViewModel.deleteTodayHistory(),
            ),
          ],
        ),
      ],
    );
  }

  SingleChildScrollView historyBody() {
    return SingleChildScrollView(
      child: ValueListenableBuilder<Box>(
        valueListenable: Hive.box(Constants.HISTORY_BOX).listenable(),
        builder: (_, box, __) {
          if (hiveService.isBoxEmpty(box)) {
            return const NoHistoryWidget();
          }
          return HistoryColumnWidget(box: box);
        },
      ),
    );
  }
}
