import 'package:flutter/material.dart';

import '../../viewModel/history_screen_view_model.dart';


class MoreOptionsWidget extends StatelessWidget {
  const MoreOptionsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
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
    );
  }
}
