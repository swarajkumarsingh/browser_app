import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

import '../../../core/common/widgets/spaces.dart';

void showDownloadDialog(
    {
    String? title,
    String? fileName,
    required String fileType,
    required int fileSize,
    String? btnText,
    required String storageLocation,
    required VoidCallback function,
    required TextEditingController controller}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      // context: context ?? contextUtils.getContext()!,

      context: navigatorKey.currentState!.overlay!.context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 0,
            title: Text(title ?? "Download file"),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: ".$fileType",
                  ),
                ),
                const VerticalSpace(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.filter),
                    const HorizontalSpace(width: 10),
                    if (fileSize != 0) Text("File Size: ${fileSize}MB"),
                  ],
                ),
                const VerticalSpace(height: 10),
                Row(
                  children: [
                    const Icon(Icons.edit),
                    const HorizontalSpace(width: 10),
                    SizedBox(
                      width: 180,
                      child: Text(
                        maxLines: 3,
                        softWrap: true,
                        storageLocation,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => appRouter.pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: function,
                child: Text(btnText ?? "Download"),
              ),
            ],
          ),
        );
      },
    );
  });
}
